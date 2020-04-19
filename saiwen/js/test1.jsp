<%@ include file="/systeminfo/init_wev8.jsp" %>


<script type="text/javascript">

    jQuery(document).ready(function () {
        var uid;
        setTimeout(function () {
            uid = jQuery('#field8190').val();
            if(uid == 150){
                $('#field8191').hide();
            }
        }, 500);
    });

</script>
