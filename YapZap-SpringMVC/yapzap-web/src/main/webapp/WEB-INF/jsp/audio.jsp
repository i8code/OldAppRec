<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
<%@ page isELIgnored="false" %>
<title>${title}</title>
<link rel="stylesheet" href="/resources/css/style.css">
<style type="text/css"></style>
</head>

<body>
	<div class="main">
		<h2>${title}</h2>
		<div class="zeus"></div>
		<audio autoplay="autoplay" controls="">
			<source src="${path}" type="audio/mp4">
			Your browser does not support the audio element.
		</audio>
		<br> <br>
		<a href="/app">Download Now</a>
	</div>
</body>

</html>