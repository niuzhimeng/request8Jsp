<script src="/classbean/com/weavernorth/cw.js"></script>
<script type="text/javascript">

    var myType = 'field7066';
    var je = 'field7067';

    // 明细表1
    var mxbNum = 'submitdtlid0';

    jQuery(document).ready(function () {
        _C.run2(je, initBind);
        _C.run2(mxbNum, getJsAll);
        _C.run2(myType, getJsAll);
    });

    function initBind(p) {
        if (p.v.o === undefined) {
            jQuery('#' + p.k + p.r).blur(function () {
                getJsAll();
            });
        }
    }

    function getJsAll(p) {
        if (p !== null && p !== undefined) {
            if (p.v.o === undefined) {
                return;
            }
        }

        var oneTotal = 0;
        var twoTotal = 0;
        var threeTotal = 0;

        var checkNums = $("#" + mxbNum).val().split(',');
        var length = checkNums.length;

        for (var i = 0; i < length; i++) {
            var jeVal = $("#" + je + '_' + checkNums[i]).val();
            if (jeVal === '' || jeVal == null) {
                continue;
            }
            var myTypeVal = $("#" + myType + '_' + checkNums[i]).val();
            if ("0" === myTypeVal) {
                oneTotal = (oneTotal * 100 + parseFloat(jeVal) * 100) / 100;
            } else if ("1" === myTypeVal) {
                twoTotal = (twoTotal * 100 + parseFloat(jeVal) * 100) / 100;
            } else if ("2" === myTypeVal) {
                threeTotal = (threeTotal * 100 + parseFloat(jeVal) * 100) / 100;
            }

        }
        alert('one; ' + oneTotal + "; two: " + twoTotal + "; three: " + threeTotal)

    }
</script>



