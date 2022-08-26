<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>날짜 입력</title>
</head>
<body>
	<form action="./date" method="POST">
		<c:if test="${ errors.under }">
			날짜확인하세요
		</c:if>
		<p> 시작 날짜 </p>
		<input type="date" name="startdate" value=<%= LocalDate.now() %> />  
		<p> 마지막 날짜 </p> 
		<input type="date" name="enddate" value=<%= LocalDate.now() %> />  
		<input type="submit" />
	</form>
</body>
</html>