<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">

    var rq1 = 'field7897';//开始日期
    var fyqj1 = 'field7064';//费用区间1

    jQuery(document).ready(function () {
        _C.run2(rq1, fuZhi);

    });

    function fuZhi(p) {
        if (p.v.o == undefined) {
            return;
        }
        var rqVal = $("#" + rq1 + p.r).val();//日期
        rqVal = parseFloat(rqVal.substring(5, 7));
        $("#" + fyqj1 + p.r).val(rqVal - 1);//费用区间
    }
</script>






<script src="/workflow/request/testJsp/cw.js"></script>
<script type="text/javascript">

    var rq1 = 'field8243';//开始日期
    var fyqj1 = 'field8242';//费用区间1

    var rq2 = 'field8262';//开始日期
    var fyqj2 = 'field8261';//费用区间2

    var rq3 = 'field8278';//开始日期
    var fyqj3 = 'field8277';//费用区间3

    jQuery(document).ready(function () {
        _C.run2(rq1, fuZhi1);
        _C.run2(rq2, fuZhi2);
        _C.run2(rq3, fuZhi3);
    });

    function fuZhi1(p) {
        if (p.v.o == undefined) {
            return;
        }
        var rqVal = $("#" + rq1 + p.r).val();//日期
        rqVal = parseFloat(rqVal.substring(5, 7));
        $("#" + fyqj1 + p.r).val(rqVal - 1);//费用区间
    }

    function fuZhi2(p) {
        if (p.v.o == undefined) {
            return;
        }
        var rqVal = $("#" + rq2 + p.r).val();//日期
        rqVal = parseFloat(rqVal.substring(5, 7));
        $("#" + fyqj2 + p.r).val(rqVal - 1);//费用区间
    }

    function fuZhi3(p) {
        if (p.v.o == undefined) {
            return;
        }
        var rqVal = $("#" + rq3 + p.r).val();//日期
        rqVal = parseFloat(rqVal.substring(5, 7));
        $("#" + fyqj3 + p.r).val(rqVal - 1);//费用区间
    }

</script>
