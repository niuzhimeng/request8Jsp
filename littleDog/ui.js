
$(function () {
    alert('引用了')
    checkCustomize = function () {
        var requestid = $("input[name='requestid']").val();
        var check = $("#field6441").val();
        var flag = true;
        var my_url = "/workflow/request/littleDog/CheckNumber.jsp";
        $.ajax({
            type: "post",
            async: false,
            url: my_url,
            data: {"check": check, "requestid": requestid},
            success: function (data) {
                data = data.replace(/\s+/g, "");
                if (data == 'formatErr') {
                    //alert('发票格式错误');
                    msgbox('提示','发票格式错误!','',null,0,'Warning')
                    flag = false;
                }else if(data != 'y'){
                    alert(data);
                    flag = false;
                }
            }
        });
        return flag;
    }
});

function msgbox(title,content,func,cancel,focus,icon){
    /*
    参数列表说明:
    title :弹出对话框的标题,标题内容最好在25个字符内,否则会导致显示图片的异常
    text  :弹出对话框的内容,可以使用HTML代码,例如<font color='red'>删除么?</font>,如果直接带入函数,注意转义
    func  :弹出对话框点击确认后执行的函数,需要写全函数的引用,例如add(),如果直接带入函数,注意转义。
    cancel:弹出对话框是否显示取消按钮,为空的话不显示,为1时显示
    focus :弹出对话框焦点的位置,0焦点在确认按钮上,1在取消按钮上,为空时默认在确认按钮上
    icon  :弹出对话框的图标
    Author:Jedliu
    Blog  :Jedliu.cublog.cn
    【网页转载请保留版权信息,实际使用时可以除去该信息】
    */
    icon="msgbox_"+icon+".png";
    create_mask();
    var temp="<div style=\"width:300px;border: 2px solid #37B6D1;background-color: #fff; font-weight: bold;font-size: 12px;\" >"
        +"<div style=\"line-height:25px; padding:0px 5px;	background-color: #37B6D1;\">"+title+"</div>"
        +"<table  cellspacing=\"0\" border=\"0\"><tr><td style=\" padding:0px 0px 0px 20px; \"><img src=\""+icon+"\" width=\"64\" height=\"64\"></td>"
        +"<td ><div style=\"background-color: #fff; font-weight: bold;font-size: 12px;padding:20px 0px ; text-align:left;\">"+content
        +"</div></td></tr></table>"
        +"<div style=\"text-align:center; padding:0px 0px 20px;background-color: #fff;\"><input type='button'  style=\"border:1px solid #CCC; background-color:#CCC; width:50px; height:25px;\" value='确定'id=\"msgconfirmb\"   onclick=\"remove();"+func+";\">";
    if(null!=cancel){temp+="&nbsp;&nbsp;&nbsp;<input type='button' style=\"border:1px solid #CCC; background-color:#CCC; width:50px; height:25px;\" value='取消'  id=\"msgcancelb\"   onClick='remove()'>";}
    temp+="</div></div>";
    create_msgbox(400,200,temp);
    if(focus==0||focus=="0"||null==focus){document.getElementById("msgconfirmb").focus();}
    else if(focus==1||focus=="1"){document.getElementById("msgcancelb").focus();}
}