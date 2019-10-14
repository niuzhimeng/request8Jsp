function convertBr(str) {
    return str.replace(/<br>/g, '\n').replace(/<br\/>/g, '\n');
}

var p=$("#input").val();
if(!p.match(/\d{8}$/)) {
    alert("请输入8位数字！")
}


$.ajax({
    type: "GET",
    datatype: 'json',
    url: "/workflow/request/testJsp/Test.jsp",
    data: "names=" + nameString,
    success: function (data) {
        alert('回调函数： ' + data)
        $('#field6551').hide(500);
        $('#field6551span').html(data.replace(/^\s*|\s*$/g, ""))
        var names = data.toString().split(',')
        for (var i = 0; i < rows1.length; i++) {
            $("#field6504_" + rows1[i]).val(names[i])
        }
    }
});

$(function () {
    checkCustomize = function () {
        var nameString = ''
        var rows1 = jQuery("#submitdtlid0").val().split(",");
        for (var i = 0; i < rows1.length; i++) {
            nameString += $("#field6550_" + rows1[i]).val() + ','
        }

        $.get("/workflow/request/testJsp/Test.jsp?names=" + nameString, function (data) {
            alert('回调函数： ' + data)
            $('#field6551').hide(500);
            $('#field6551span').html(data.replace(/^\s*|\s*$/g, ""))
            var names = data.toString().split(',')
            for (var i = 0; i < rows1.length; i++) {
                $("#field6504_" + rows1[i]).val(names[i])
            }
        })
        return false;
    }

})