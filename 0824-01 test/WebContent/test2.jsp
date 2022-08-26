<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>simpleMap</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script
	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=l7xx7032c4f730ba417a8e77265dac6dac5b"></script>
<script type="text/javascript">
	var map;

	var marker_s, marekr_e, waypoint;
	var resultMarkerArr = [];
	//경로그림정보
	var drawInfoArr = [];
	var resultInfoArr = [];

	function initTmap() {
		resultMarkerArr = [];

		// 1. 지도 띄우기
		map = new Tmapv2.Map("map_div", {
			center : new Tmapv2.LatLng(37.405278291509404, 127.12074279785197),
			width : "100%",
			height : "400px",
			zoom : 14,
			zoomControl : true,
			scrollwheel : true

		});

		// 2. 시작, 도착 심볼찍기

		// 시작
		marker_s = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(37.402688, 127.103259),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		resultMarkerArr.push(marker_s);
		// 도착
		marker_e = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(37.414382, 127.142571),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		resultMarkerArr.push(marker_e);

		// 3. 경유지 심볼 찍기
		marker = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(37.399569, 127.103790),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_1.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		resultMarkerArr.push(marker);

		marker = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(37.399400, 127.123296),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_2.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		resultMarkerArr.push(marker);

		marker = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(37.397153, 127.113403),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_3.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		resultMarkerArr.push(marker);

		marker = new Tmapv2.Marker(
				{
					position : new Tmapv2.LatLng(37.410135, 127.121210),
					icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_4.png",
					iconSize : new Tmapv2.Size(24, 38),
					map : map
				});
		resultMarkerArr.push(marker);

		// 4. 경로탐색 API 사용요청
		var routeLayer;
		$("#btn_select")
				.click(
						function() {

							var searchOption = $("2").val(); //수정 목록

							var headers = {};
							headers["appKey"] = "l7xx7032c4f730ba417a8e77265dac6dac5b";//수정 목록
							headers["Content-Type"] = "application/json";

							var param = JSON.stringify({
								"startName" : "출발지",
								"startX" : "127.103259",//수정 목록
								"startY" : "37.402688",
								"startTime" : "201708081103",
								"endName" : "도착지",
								"endX" : "127.142571",
								"endY" : "37.414382",
								"viaPoints" : [ {
									"viaPointId" : "test01",
									"viaPointName" : "name01",
									"viaX" : "127.103790",
									"viaY" : "37.399569"
								}, {
									"viaPointId" : "test02",
									"viaPointName" : "name02",
									"viaX" : "127.123296",
									"viaY" : "37.399400"
								}, {
									"viaPointId" : "test03",
									"viaPointName" : "name03",
									"viaX" : "127.113403",
									"viaY" : "37.397153"
								}, {
									"viaPointId" : "test04",
									"viaPointName" : "name04",
									"viaX" : "127.121210",
									"viaY" : "37.410135"
								} ],
								"reqCoordType" : "WGS84GEO",
								"resCoordType" : "EPSG3857",
								"searchOption" : searchOption
							});

							$
									.ajax({
										method : "POST",
										url : "https://apis.openapi.sk.com/tmap/routes/routeSequential30?version=1&format=json",//
										headers : headers,
										async : false,
										data : param,
										success : function(response) {

											var resultData = response.properties;
											var resultFeatures = response.features;

											// 결과 출력
											var tDistance = "총 거리 : "
													+ (resultData.totalDistance / 1000)
															.toFixed(1)
													+ "km,  ";
											var tTime = "총 시간 : "
													+ (resultData.totalTime / 60)
															.toFixed(0) + "분  ";

											$("#result")
													.text(tDistance + tTime);

											//기존  라인 초기화

											if (resultInfoArr.length > 0) {
												for ( var i in resultInfoArr) {
													resultInfoArr[i]
															.setMap(null);
												}
												resultInfoArr = [];
											}

											for ( var i in resultFeatures) {
												var geometry = resultFeatures[i].geometry;
												var properties = resultFeatures[i].properties;
												var polyline_;

												drawInfoArr = [];

												if (geometry.type == "LineString") {
													for ( var j in geometry.coordinates) {
														// 경로들의 결과값(구간)들을 포인트 객체로 변환 
														var latlng = new Tmapv2.Point(
																geometry.coordinates[j][0],
																geometry.coordinates[j][1]);
														// 포인트 객체를 받아 좌표값으로 변환
														var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
																latlng);
														// 포인트객체의 정보로 좌표값 변환 객체로 저장
														var convertChange = new Tmapv2.LatLng(
																convertPoint._lat,
																convertPoint._lng);

														drawInfoArr
																.push(convertChange);
													}

													polyline_ = new Tmapv2.Polyline(
															{
																path : drawInfoArr,
																strokeColor : "#FF0000",
																strokeWeight : 6,
																map : map
															});
													resultInfoArr
															.push(polyline_);

												} else {
													var markerImg = "";
													var size = ""; //아이콘 크기 설정합니다.

													if (properties.pointType == "S") { //출발지 마커
														markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
														size = new Tmapv2.Size(
																24, 38);
													} else if (properties.pointType == "E") { //도착지 마커
														markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
														size = new Tmapv2.Size(
																24, 38);
													} else { //각 포인트 마커
														markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
														size = new Tmapv2.Size(
																8, 8);
													}

													// 경로들의 결과값들을 포인트 객체로 변환 
													var latlon = new Tmapv2.Point(
															geometry.coordinates[0],
															geometry.coordinates[1]);
													// 포인트 객체를 받아 좌표값으로 다시 변환
													var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
															latlon);

													marker_p = new Tmapv2.Marker(
															{
																position : new Tmapv2.LatLng(
																		convertPoint._lat,
																		convertPoint._lng),
																icon : markerImg,
																iconSize : size,
																map : map
															});

													resultMarkerArr
															.push(marker_p);
												}
											}
										},
										error : function(request, status, error) {
											console.log("code:"
													+ request.status + "\n"
													+ "message:"
													+ request.responseText
													+ "\n" + "error:" + error);
										}
									});
						});
	}

	function addComma(num) {
		var regexp = /\B(?=(\d{3})+(?!\d))/g;
		return num.toString().replace(regexp, ',');
	}
</script>
</head>
<body onload="initTmap()">
	<!-- 맵 생성 실행 -->
	<p id="result"></p>
	<p>교통최적+최소시간</p>
	<button id="btn_select">적용하기</button>

	<div id="map_wrap" class="map_wrap">
		<div id="map_div"></div>
	</div>
</body>
</html>
