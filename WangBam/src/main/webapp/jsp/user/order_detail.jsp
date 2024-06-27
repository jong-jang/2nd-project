<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/jsp/common/header.jsp" %>
<div class="order-container">
    <div class="order-header">
        <h2>주문번호: ${ovo.or_idx}</h2>
    </div>
    <div class="order-status">
        <span class="status-value">${ovo.or_status_code}</span>
    </div>
    <c:forEach var="odvo" items="${ovo.od_list}">
    <div class="order-item">
        <img src="https://via.placeholder.com/50" alt="Product Image">
        <div class="order-item-details">
            <h3>${odvo.pvo.pd_name}</h3>
            <p>${odvo.pvo.pd_sale_price}원  &nbsp; &nbsp;  ${odvo.od_cnt}개</p>
        </div>
        <div class="order-actions">
    		<button onclick="location.href='orderlist'">리뷰 작성</button>
		</div>
    </div>
    </c:forEach>
    <div class="order-total-price">
            <span>총 결제금액: ${ovo.or_total_price}원</span>
        </div>
</div>
<%-- 배송조회--%>
<h2 style="text-align: center; margin-top: 20px;">배송조회</h2>
<iframe src="https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=${ovo.or_tracking_number}&displayHeader=N" class="order-delivery-info" id="order-delivery-info" name="order-delivery-info" style="width: 100%; height: 1250px; display: block; margin-top: 10px;"></iframe>
<div class="order-recipient-info">
    <h3>받는사람 정보</h3>
    <h>받는사람: ${ovo.or_name}</h>
    <p>연락처: ${ovo.or_tel}</p>
    <p>받는주소: ${ovo.or_addr} ${ovo.or_addr_detail}</p>
    <p>배송요청사항: ${ovo.or_request}</p>
    <br/>
    <h3>결제 정보</h3>
    <span>결제수단: </span><span id="payment-method"></span>
    <br/>
    <p>총 결제금액: ${ovo.or_total_price}원</p>
    <span>결제상태: </span><span id="payment-status"></span>
    <br/>
    <br/>
    <h3>결제영수증 정보</h3>
    <iframe id="receipt-url" src="" style="width: 100%; height: 100%; display: block; margin-top: 10px;"></iframe> 
</div>

<div class="order-actions">
    <button onclick="location.href='?type=orderlist'">주문목록 돌아가기</button>
    <button id="order-cancel-button">주문취소</button>
</div>
<form id="order-cancel-form" action="/WangBam/" method="post" style="display: none;">
    <input type="hidden" name="or_idx" value="${ovo.or_idx}">
    <input type="hidden" name="type" value="ordercancel">
</form>
  <%@include file="/jsp/common/footer.jsp" %>
<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
<script src="${pageContext.request.contextPath}/js/Payment.js"></script>
  
  <script>
    $(document).ready(function(){
    	let data = getPaymentByOrIdx(${ovo.or_idx})
        if(data.status == 'PAID'){
            $('#payment-status').text('결제 완료');
        }else if(data.status == 'CANCELLED'){
            $('#payment-status').text('결제 취소');
        }else if(data.status == 'FAILED'){
            $('#payment-status').text('결제 실패');
        }else if(data.status == 'PARTIAL_CANCELLED'){
            $('#payment-status').text('결제 부분취소');
        }else if(data.status == 'PAY_PENDING'){
            $('#payment-status').text('결제 완료 대기');
        }else if(data.status == 'READY'){
            $('#payment-status').text('결제 대기');
        }else if(data.status == 'VIRTUAL_ACCOUNT_ISSUED'){
            $('#payment-status').text('가상계좌 발급 완료');
        }
        if(data.method.type == 'PaymentMethodCARD'){
            $('#payment-method').text(data.method.card.name);
        }else if(data.method.type == 'PaymentMethodEasyPay'){
            $('#payment-method').text(data.method.provider);
        }
        $('#receipt-url').attr('src', data.receiptUrl);
        
        $('#order-cancel-button').click(function(){
        	if(confirm('주문을 취소하시겠습니까?')){
                $('#order-cancel-form').submit();
            }
        });
    });
  </script>
  </body>
</html>