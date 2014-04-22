<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>YapZap Metrics</title>

<!-- must include jquery -->
<script
	src="resources/js/jquery.min.js"></script>

<!-- must include bootstrap -->
<link rel="stylesheet" type="text/css"
	href="resources/css/bootstrap.min.css">
<script
	src="/resources/js/bootstrap.min.js"></script>


<!--  And include the metrics-watcher library -->
<script src="/resources/js/metrics-watcher.js"></script>
<!-- And include the metrics stylesheet -->
<link href="/resources/css/metrics-watcher-style.css" rel="stylesheet">

<script>
	var hasGraphs = false;
	// See example-metrics.js for sample of the Metrics-servlet format
	function addGraphs(data) {
		var timers = data.timers;

		for (timer in timers) {
			var timerId = timer.replace(/[-.]/g, "_");
			$("#timers").append("<div id='"+timerId+"'></div>");
			var name = timer.replace(/[_]/g, " ");

			metricsWatcher
					.addTimer(timerId, "", timer, 50, name, "requests", 0.3);
		}
		/*
		metricsWatcher.addJvm("jvmExample", "jvm", "JVM Statistics");

		metricsWatcher.addCache("queryCache", "net.sf.ehcache.Cache.cacheName", "Ehcache");
		//			metricsWatcher.addLog4j("log4jExample", "org.apache.log4j.Appender", "Log4j");
		metricsWatcher.addWeb("webExample", "com.codahale.metrics.servlet.AbstractInstrumentedFilter", "Web Server");
		 */
		metricsWatcher.initGraphs();
	}

	$(document).ready(function() {
		keepUpdatingGraphs();
	});

	function keepUpdatingGraphs() {
		downloadMetricData();

		setTimeout(keepUpdatingGraphs, 1000);
	}

	function downloadMetricData() {
		//metricsWatcher.updateGraphs(exampleMetricsData);
		// Normally metric data will be loaded from a servlet with an Ajax call like the following.
		// For this example, it is hardcoded.

		url = "/CodahaleMetrics/metrics";
		$.ajax({
			contentType : "application/json",
			url : url,
			success : function(data) {
				if (!hasGraphs) {
					addGraphs(data);
					hasGraphs = true;
				}
				metricsWatcher.updateGraphs(data);
			},
			error : function(xhr, ajaxOptions, thrownError) {
			},
			async : false
		});
	}
</script>
</head>
<body>
	<nav class="navbar navbar-default navbar-static-top" role="navigation">
		<a class="btn navbar-btn" data-toggle="collapse"
			data-target=".navbar-collapse"> <span class="glyphicon-bar"></span>
			<span class="glyphicon-bar"></span> <span class="glyphicon-bar"></span>
		</a> <a class="navbar-brand" href="#">YapZap Metrics</a>
		<div class="navbar-collapse">
			<ul class="nav"></ul>
		</div>
	</nav>

	<div class="container mainContent">
		<div class="row" id="timers"></div>
	</div>
</body>
</html>