package me.yapzap.api.v1.updaters;

import java.util.List;

import me.yapzap.api.v1.database.FriendDBHelper;
import me.yapzap.api.v1.database.NotificationDBHelper;
import me.yapzap.api.v1.database.RecordingDBHelper;
import me.yapzap.api.v1.database.TagDBHelper;
import me.yapzap.api.v1.models.FriendRelation;
import me.yapzap.api.v1.models.Notification;
import me.yapzap.api.v1.models.NotificationType;
import me.yapzap.api.v1.models.Recording;
import me.yapzap.api.v1.models.Tag;

import org.springframework.util.CollectionUtils;

public class NotificationManager {

    public static class AddNotification implements Runnable {

        private String usernameBy;
        private String recordingId;
        private NotificationType type;
        private TagDBHelper tagDBHelper;
        private RecordingDBHelper recordingDBHelper;
        private NotificationDBHelper notificationDBHelper;

        public AddNotification(String usernameBy, String recordingId, NotificationType type, TagDBHelper tagDBHelper, RecordingDBHelper recordingDBHelper, NotificationDBHelper notificationDBHelper) {
            super();
            this.usernameBy = usernameBy;
            this.recordingId = recordingId;
            this.type = type;
            this.tagDBHelper = tagDBHelper;
            this.recordingDBHelper = recordingDBHelper;
            this.notificationDBHelper = notificationDBHelper;
        }

        @Override
        public void run() {
            // Find the recording
            Recording recording = recordingDBHelper.getById(recordingId);
            if (recording == null) {
                // doesn't exist
                return;
            }

            String usernameFor = recording.getUsername();

            if (usernameFor.equals(usernameBy)) {
                // same user; no notification
                return;
            }

            // Grab the tag
            Tag tag = tagDBHelper.getByName(recording.getTagName());

            // Create the recording
            Notification notification = new Notification();

            notification.setUsernameBy(usernameBy);
            notification.setUsernameFor(usernameFor);
            notification.setTagName(tag.getName());
            notification.setMood(tag.getMood());
            notification.setIntensity(tag.getIntensity());
            notification.setRecordingId(recordingId);
            notification.setType(type);

            notificationDBHelper.createNotification(notification);
        }

    }

    public static class NotifyFriends implements Runnable {

        private Recording newRecording;
        private NotificationType type;
        private TagDBHelper tagDBHelper;
        private NotificationDBHelper notificationDBHelper;
        private FriendDBHelper friendDBHelper;

        public NotifyFriends(Recording newRecording, NotificationType type, TagDBHelper tagDBHelper, NotificationDBHelper notificationDBHelper, FriendDBHelper friendDBHelper) {
            super();
            this.newRecording = newRecording;
            this.type = type;
            this.tagDBHelper = tagDBHelper;
            this.notificationDBHelper = notificationDBHelper;
            this.friendDBHelper = friendDBHelper;
        }

        @Override
        public void run() {
            List<FriendRelation> friends = friendDBHelper.getAllForUser(newRecording.getUsername());

            for (FriendRelation friend : friends) {
                List<Notification> existingNotifications = notificationDBHelper.getAllBy(newRecording.getUsername(), friend.getFriendId(), newRecording.get_id());

                if (!CollectionUtils.isEmpty(existingNotifications)) {
                    // This relation already has a notification
                    continue;
                }

                Tag tag = tagDBHelper.getByName(newRecording.getTagName());

                // Create the recording
                Notification notification = new Notification();

                notification.setUsernameBy(newRecording.getUsername());
                notification.setUsernameFor(friend.getFriendId());
                notification.setTagName(tag.getName());
                notification.setMood(tag.getMood());
                notification.setIntensity(tag.getIntensity());
                notification.setRecordingId(newRecording.get_id());
                notification.setType(type);

                notificationDBHelper.createNotification(notification);
            }
        }

    }

}
