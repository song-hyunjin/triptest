<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<input type="text" id="start_address" placeholder="주소 검색"
		onclick="sample3_execDaumPostcode('start_address')"
		readonly="readonly">
	
	<!-- <input type="text" id="end_address" placeholder="도착 주소"
	onclick="sample3_execDaumPostcode('end_address')"
		readonly="readonly"> -->

	<input type="button" onclick="choice_complete()" value="선택완료">
	<div id="wrap"
		style="display: none; border: 1px solid; width: 500px; height: 300px; margin: 5px 0; position: relative">
		<img src="//t1.daumcdn.net/postcode/resource/images/close.png"
			id="btnFoldWrap"
			style="cursor: pointer; position: absolute; right: 0px; top: -1px; z-index: 1"
			onclick="foldDaumPostcode()" alt="접기 버튼">
	</div>

	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		// 우편번호 찾기 찾기 화면을 넣을 element
		var element_wrap = document.getElementById('wrap');

		function foldDaumPostcode() {
			// iframe을 넣은 element를 안보이게 한다.
			element_wrap.style.display = 'none';
		}

		function sample3_execDaumPostcode(e) {
			// 현재 scroll 위치를 저장해놓는다.
			var currentScroll = Math.max(document.body.scrollTop,
					document.documentElement.scrollTop);
			new daum.Postcode(
					{
						oncomplete : function(data) {
							// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

							// 각 주소의 노출 규칙에 따라 주소를 조합한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							var addr = ''; // 주소 변수

							//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
							if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
								addr = data.roadAddress;
							} else { // 사용자가 지번 주소를 선택했을 경우(J)
								addr = data.jibunAddress;
							}


							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							/* document.getElementById('sample3_postcode').value = data.zonecode; */
							document.getElementById(e).value = addr;

							// iframe을 넣은 element를 안보이게 한다.
							// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
							element_wrap.style.display = 'none';

							// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
							document.body.scrollTop = currentScroll;
							
						},
						// 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
						onresize : function(size) {
							element_wrap.style.height = size.height + 'px';
						},
						width : '100%',
						height : '100%'
					}).embed(element_wrap);

			// iframe을 넣은 element를 보이게 한다.
			element_wrap.style.display = 'block';
		}
		
		function choice_complete() {
			 window.location.href = './date'
			 console.log('dskosd');
		}
	</script>
</body>
</html>