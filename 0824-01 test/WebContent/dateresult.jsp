<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>날짜 확인 , 장소 추가 구간</title>
</head>
<body>
	<c:forEach var="dateList" items="${ dateList }" varStatus="status">
		<p><c:out value="${dateList}" /></p>
		<button type="button" class="plusplace" onclick="location.href='searchTest.jsp'"> 장소추가 !!</button>
	</c:forEach>
</body>
</html>