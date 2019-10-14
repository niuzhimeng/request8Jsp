

function GlobalReger(f){
	var w = window;
	while (w != top) {
		f(w);
		w = w.parent;
	}
}


/**
Crivia Work Flow Java Script Function Group.
**/
top.CriviaWorkFlowJavaScriptFunctions = 
	undefined!=top.CriviaWorkFlowJavaScriptFunctions
	?top.CriviaWorkFlowJavaScriptFunctions:
//var _C =
{
		ev : '8'
		,UEF : '.c'/*UEF*/
		,ui : {
			_ : 'UserInterface'
			,isPC : function(){return '0' == this._;}
			,isMobile : function(){return '2' == this._;}
		}
		,rsImg : function(){
			return '8' == this.ev
				? '<img src="/images/BacoError_wev8.gif" align="absmiddle">'
				: '<img src="/images/BacoError.gif" align="absmiddle">';
		}
		,_rsSetting : []
/**
{
	Desc : 'Requird Switcher | 必填状态变更'
	,Params : {
		Field ID : String
		,Is Requird : Boolean
	} 
}
 */
		,rs : function (f,isRequird){
			var _c = this;
			if (! f){
				return;
			}
			_c._rsSetting[f] = {r:isRequird};
			var img = _c.rsImg();
			
			var coA = jQuery('input[name="inputcheck"]');
			var coB = jQuery('input[name="needcheck"]');
			if (coA.length&&coB.length){
				var v = _c.v(f);
				var checkerA = coA.val();
				var checkerB = coB.val();
				var oldChange = jQuery('#'+f).attr('onchange');
				if (isRequird) {
					checkerA=checkerA.replace(','+f,'');
					checkerB=checkerB.replace(','+f,'');
					checkerA +=','+f;
					checkerB +=','+f;
					if ('' == v){
						var jf = jQuery('#field_'+f.substring(5)+'span');
						if (jf.length){
							jf.html(img+'(必填)');
							jf.show();
						} else if ('8' == _c.ev
						&& jQuery('#'+f+'spanimg').length){
							_c.t(f+'spanimg',img,true);
						} else {
							_c.t(f,img);
						}
					}
					if ('8' == _c.ev) {
						jQuery('#'+f).attr('viewtype','1');
						if (jQuery('#'+f+'spanimg').length){
							jQuery('#'+f).attr('onchange',oldChange
								+';checkinput2('+'\''+f+'\' , \''+f+'spanimg\' '
								+', this.getAttribute(\'viewtype\'));');
						} else {
							jQuery('#'+f).attr('onchange',oldChange
								+';checkinput2('+'\''+f+'\' , \''+f+'span\' '
								+', this.getAttribute(\'viewtype\'));');
						}
					}
				}else{
					checkerA=checkerA.replace(','+f,'');
					checkerB=checkerB.replace(','+f,'');
					jQuery('#field_'+f.substring(5)+'span').hide();
					if ('8' == _c.ev){
						jQuery('#'+f).attr('viewtype','0');
						if (jQuery('#'+f+'spanimg').length){
							if (_c.t(f+'spanimg',undefined,true).indexOf('src="/images/BacoError_wev8.gif"') > -1){
								_c.t(f+'spanimg','',true);
							}
						} else if (jQuery('#'+f+'span').length) {
							if (_c.t(f).indexOf('src="/images/BacoError_wev8.gif"') > -1){
								_c.t(f,'');
							}
						}
					} else {
						if (_c.t(f).indexOf('src="/images/BacoError.gif"') > -1){
							_c.t(f,'');
						}
					}
				}
				
				coA.val(checkerA);
				coB.val(checkerB);
			}

			var  coC = jQuery('#'+f+'_ismandfield');
			var  coD = jQuery('#'+f+'_d_ismandfield');
			if (coC.length){
				if (isRequird){
					jQuery('#'+f+'_ismandfield').attr('name','mustInput');
					jQuery('#'+f+'_ismandspan').html(img);
					jQuery('#'+f+'_ismandspan').show();
				} else {
					jQuery('#'+f+'_ismandfield').attr('name','notmandfield');
					jQuery('#'+f+'_ismandspan').html('');
				}
			} else if (coD.length) {
				if (isRequird){
					jQuery('#'+f+'_d_ismandfield').attr('name','mustInput');
					jQuery('#'+f+'_d_ismandspan').html(img);
					jQuery('#'+f+'_ismandspan').show();
				} else {
					jQuery('#'+f+'_d_ismandfield').attr('name','notmandfield');
					jQuery('#'+f+'_d_ismandspan').html('');
				}
			}
		}
/**
{
	Desc : 'Sub Table Each | 子表遍历'
	,Params : {
		Each Field ID : String
		,Each Function : Function
	} 
	,Return : {
		Count : Sub Table Size (Int)
		,Sum : Sub Table Data Sum (Double)
		,Values : Sub Table Values Map
		,Concat : Values Concat (Function , Param : Concater Default ',')
	}
}
 */
		,stEach : function (id , f , mobileReadOnly){
			if ('string' != typeof id){
				return;
			}
			var _c = this;
			var count = 0;
			var sum = 0;
			var values = {};
			var each = function(fs){
				if (!fs.length){
					return false;
				}
				for (var k = 0; k < fs.length; k++){
					var kr = jQuery(fs[k]).attr('id');
					if (false
					|| 'string' != typeof kr
					|| kr.match(/field\d+_?\d?__/)
					|| kr.match(/field\d+_\d+_ismandfield/)
					|| kr.indexOf('_ismandfield')==id.length){
						continue;
					}
					var rn = kr.indexOf('_d')==id.length
						? kr.substring(id.length,kr.length-2)
						: kr.substring(id.length);
					var v = _c.v(id + rn);
					count++;
					sum = sum + _c.n(v, 0);
					values[rn] = v;
					if (! f){
						continue;
					}
					if (mobileReadOnly){
						f(rn);
					} else {
						_c.emst(_c.f2stI(id+rn), rn, function(){
							f(rn);
						});
					}
				}
				return true;
			};
			if(each(jQuery('input[id^="' + id + '"]'))){
			} else if (each(jQuery('select[id^="' + id + '"]'))){
			} else if (each(jQuery('textarea[id^="' + id + '"]'))){
			}
			return {
				count : count
				,sum : sum
				,values : values
				,concat : function(concater){
					if (undefined == concater){
						concater = ',';
					}
					var m = this.values;
					var s = '';
					for (var k in m){
						if ('' != s){
							s = s + concater;
						}
						s = s + m[k];
					}
					return s;
				}
			};
		}
/**
{
	Desc : 'Value Keeper | 值变更储存'
	,Params : {
		Map Key : String
		,New Value : String
		,Map : Java Script Object
	} 
	,Return : {
		Type : Boolean
		,Desc : 'Old Value == New Value ? True : False'
	}
}
 */
		,vK : function (k , v , m){
			if (k in m){
				if (m[k] == v){
					return true;
				}
			}
			m[k] = v;
			return false;
		}
/**
{
	Desc : 'Value | 值操作'
	,Params : {
		Field ID : String
		,Input Value : String (M Get Or Set)
	} 
}
 */
		,_vom : {}
		,v : function(id , v){
			var o;
			if (id in this._vom){
				o = this._vom[id];
			} else {
				o = document.getElementById(id);
				if (! o){
					o = document.getElementById('dis'+id);
					if (! o){
						return;
					}
				}
				if ('string'==typeof o.tagName
				&& 'input'==o.tagName.toLowerCase()){
					this._vom[id] = o;
				}
			}
//			var o = document.getElementById(id);
//			if (! o){
//				o = document.getElementById('dis'+id);
//				if (! o){
//					return;
//				}
//			}
			if (undefined == v){
				return o.value;
			} else {
				o.value = v;
				if ('hidden' == o.getAttribute('type')){
					this.t(id, v);
				}
				jQuery(o).change();
				jQuery(o).blur();
				if ('8' == this.ev
				&& jQuery('#'+id+'spanimg').length){
					this.t(id+'spanimg',(!v?this.rsImg():''),true);
				}
				return o;
			}
		}
/**
{
	Desc : 'Text | 文本操作'
	,Params : {
		Field ID : String
		,Input Text : String (M Get Or Set)
		,Un Complete End : Boolean (M Default : False)
	} 
}
 */
		,t : function(id , t , uce){
			var end = 'span';
			if (uce){
				end = '';
			}
			var o = document.getElementById(id + end);
			if (! o){
				return;
			}
			if (undefined == t){
				return o.innerHTML;
			} else {
				o.innerHTML = t;
			}
		}
/**
{
	Desc : 'Value & Text | 值&文本赋予'
	,Params : {
		Field ID : String
		,Input Value : String
		,Input Text : String (M Default Value)
		,Text ID : String (M Default Field ID)
	} 
}
 */
		,vt : function(f , v , t , s){
			var _c = this;
			if (f == undefined || v == undefined){
				return;
			}
			if (t == undefined){
				t = v;
			}
			if (s == undefined){
				s = f;
			}
			_c.v(f, v);
			_c.t(s, t);
		}
/**
{
	Desc : 'Value & Show | 值&文本赋予'
	,Params : {
		Field ID : String
		,Input Value : String
		,Input Text : String (M Default Value)
	} 
}
 */
		,vs : function(f , v , t){
			var o = document.getElementById(f);
			if (! o){
				return;
			}
			this.v(f , v);
			if (false
			|| o.tagName == 'hidden' 
			|| (true
			&& o.tagName == 'input'
			&& o.getAttribute('type') == 'hidden')){
				if (! t){
					t = v;
				}
				this.t(f , t);
			}
		}
/**
{
	Desc : 'A Label Text | 各种链接中的文本'
	,Params : {
		Field ID : String
	} 
	,Return : Text
}
*/
		,at : function(f , ue){
			if (! f){
				return;
			}
			var e = 'span';
			if (ue){
				e = '';
			}
			return jQuery('#'+f+e).children('a').html();
		}
/**
{
	Desc : 'Add Function | 追加函数'
	,Params : {
		New Function : Function
		,Old Function Var : String (M Default : window.doSubmit)
	} 
}
 */
		,af : function(n , o){
			if (! n){
				return;
			}
			if (! o){
				o = window.doSubmit;
			}
			var f = o;
			o = function(p){
				n(f , p);
			};
		}
/**
{
	Desc : 'To Number | 数字转换'
	,Params : {
		String : String
		,Default Value : Target
		,Is Int : Boolean (M Default : False)
	} 
}
 */
		,n : function(s , dv , isInt){
			if ('number' == typeof s){
				return s;
			} else if ('string' != typeof s) {
				return dv;
			}
			var n;
			if (isInt){
				n = parseInt(s);
			} else {
				n = parseFloat(s.replace(/\,/g,''));
			}
			return isNaN(n) ? dv : n;
		}
/**
{
	Desc : 'Value To Number | 取值数字转换'
	,Params : {
		String : Field ID
		,Default Value : Target
		,Is Int : Boolean (M Default : False)
	} 
}
 */
		,vn : function(id , dv , isInt){
			return this.n(this.v(id), dv, isInt);
		}
/**
{
	Desc : 'Listener Runner | 启动监视器'
	,Params : {
		Option : Object
		,Example : {
			t : 'Time , Number , (M Default : 100)'
			,f : [
				{
					k : 'Example Main Table Field ID , String'
					,f : function(ov , nv){
						alert(
							'Old Value : ' + ov
							+ '\n' + 'New Value : ' + nv
						);
					}
					,f2 : function(nv , ov , k){
						alert(
							'New Value : ' + nv
							+ '\n' + 'Old Value : ' + ov
							+ '\n' + 'Field Key : ' + k
						);
					}
				},{
					k : 'Example Sub Table Field ID , String'
					,d : 'Sub Table Flag , Default : False'
					,f : function(ov , nv , r){
						alert(
							'Old Value : ' + ov
							+ '\n' + 'New Value : ' + nv
							+ '\n' + 'Row Index : ' + r
						);
					}
					,f2 : function(r , nv , ov , k){
						alert(
							'Row Index : ' + r
							+ '\n' + 'New Value : ' + nv
							+ '\n' + 'Old Value : ' + ov
							+ '\n' + 'Field Key : ' + k
						);
					}
					,f3 : function(p){
						alert(
							'Row Index : ' + p.r
							+ '\n' + 'New Value : ' + p.v.n
							+ '\n' + 'Old Value : ' + p.v.o
							+ '\n' + 'Field Key : ' + p.k
						);
					}
				}
			]
		}
	} 
}
 */
		,run : function(o){
			var _c = this;
			//Init Param.
			if (! o){
				o = {};
			}
			//Run Timer When Option Is Undefined.
			if (! _c._listenerOption){
				window.setInterval(
						'CriviaWorkFlowJavaScriptFunctions._cwjsListener()'
						, _c.n(o.t, 100, true));
			}
			//Old Param.
			if (! o.k){
				//Setting Options.
				_c._listenerOption = o;
			} 
			//New Param.
			else {
				//First Setting.
				if (! _c._listenerOption || ! _c._listenerOption.f){
					//Init Param.
					_c._listenerOption = { f : [] };
				}
				//Fields Size.
				var s = _c._listenerOption.f.length;
				//Each Check.
				for (var k = 0; k < s; k++){
					//Temp Field.
					var f = _c._listenerOption.f[k];
					//Repeat Key.
					if (f.k == o.k){
						//Replace Type.
						var t = _c.n(f.t, 0, true);
						//
						switch (t) {
						//Replace.
						case -1:
							f._fs = [o.f];
							f._f2s = [o.f2];
							f._f3s = [o.f3];
							return;
						//Add To Begin.
						case 1:
							f._fs.splice(0,0,o.f);
							f._f2s.splice(0,0,o.f2);
							f._f3s.splice(0,0,o.f3);
							return;
						//Add To End.
						default:
							f._fs[f._fs.length] = o.f;
							f._f2s[f._f2s.length] = o.f2;
							f._f3s[f._f3s.length] = o.f3;
							return;
						}
					}
				}//End Of Each.
				//Init Functions.
				o._fs = [o.f];
				o._f2s = [o.f2];
				o._f3s = [o.f3];
				//Regedit Field.
				_c._listenerOption.f[s] = o;
			}
		}
		,run2 : function(k,f){
			if (!k || !f){
				return;
			}
			var _c = this;
			jQuery(document).ready(function(){
				_c.run({k:k,f3:f});
			});
		}
		,_listenerOption : undefined
		,_cwjsListener : function(){
			var _c = this;
			//Requird Switch Setting.
			for (var rsf in _c._rsSetting){
				var o = _c._rsSetting[rsf];
				var v = _c.v(rsf);
				if (v == o.v) continue;
				o.v = v;
				if (!!o.r&&!v){
					var jf = jQuery('#field_'+rsf.substring(5)+'span');
					if (jf.length){
						jf.html(_c.rsImg()+'(必填)');
						jf.show();
					} else if ('8' == _c.ev
					&& jQuery('#'+rsf+'spanimg').length){
						_c.t(rsf+'spanimg',_c.rsImg(),true);
					} else {
						_c.t(rsf,_c.rsImg());
					}
				} else if (!o.r||!!v) {
					if ('8' == _c.ev){
						if (jQuery('#'+rsf+'spanimg').length){
							if (_c.t(rsf+'spanimg',undefined,true)
									.indexOf('src="/images/BacoError_wev8.gif"')
										> -1){
								_c.t(rsf+'spanimg','',true);
							}
						} else if (jQuery('#'+rsf+'span').length) {
							if (_c.t(rsf)
									.indexOf('src="/images/BacoError_wev8.gif"')
										> -1){
								_c.t(rsf,'');
							}
						}
					} else {
						if (_c.t(f).indexOf('src="/images/BacoError.gif"') > -1){
							_c.t(f,'');
						}
					}
				}
			}
			//Check Option.
			if (! _c._listenerOption){
				return;
			}
			//Fields.
			var fs = _c._listenerOption.f;
			//Fields Check.
			if (! fs){
				return;
			}
			//Check Value And Run Functions.
			for (var n = 0; n < fs.length; n++){
				//Value Map.
				var m = _c._cwjsListenerValueMap;
				//Field Option.
				var f = fs[n];
				//Check Key.
				if (! f.k){
					continue;
				}
				//Function : Check & Run.
				//Param : Temp Field , Field Key , Row Number.
				var cr = function(t , fk , r){
					//Old Value.
					var ov = m[fk];
					//New Value.
					var nv = _c.v(fk);
					//Check & Value Keep.
					if (_c.vK(fk, nv, m)){
						return;
					}
					//Function : Sequnce Runner.
					//Param : Sequnce , Runner , Bak Function.
					var sr = function(s , r , b){
						//Check Runner.
						if (! r){
							return;
						}
						//Check Sequnce.
						if (s){
							//Check Sequnce.
							for (var k = 0; k < s.length; k++){
								//Run.
								r(s[k]);
							}
						} else {
							//Run Bak Function.
							r(b);
						}
					};
					//Run Function Sequece.
					var rfs = function(){
						//F1.
						sr(t._fs, function(f){
							//Check Function.
							if (f){
								//Run.
								f(ov , nv , r);
							}
						}, t.f);
						//F2.
						sr(t._f2s, function(f){
							//Check Function.
							if (f){
								//Run.
								f(r , nv , ov , t.k);
							}
						}, t.f2);
						//F3.
						sr(t._f3s, function(f){
							//Check Function.
							if (! f){
								return;
							}
							//F3 Param.
							var p = {
								//Key.
								k : t.k
								//Detail.
								,d : t.d
								//Values.
								,v : {
									//Old.
									o : ov
									//New.
									,n : nv
								}
								//Row Num.
								,r : r
								//Sub Table Index.
								,stI : _c.f2stI(t.k)
							};
							//Run.
							f(p);
						}, t.f3);
					};
					//Check Row Number.
					if (r){
						//Edit Mobile Sub Table.
						_c.emst(_c.f2stI(t.k), r, rfs);
					} else {
						//Run Main Table.
						rfs();
					}
				};
				//All Each.
				_c.stEach(f.k, function(r){
					//Check & Run.
					cr(f , f.k + r , r);
				} , true);
			}
		}
		,_cwjsListenerValueMap : {}
/**
{
	Desc : 'Sub Table Button | 子表按钮附加'
	,Params : {
		Option : Object
		,Example : {
			stIndex : 'Sub Table Index , Int'
			,text : 'Button Text , String (M Default : 导入)' 
			,key : 'Button Key , String (M Default : T)'
			,name : 'Button Name , String (M Default : autoCreate)' 
			,onclick : 'On Click Act , String'
		}
	} 
}
 */
		,stButton : function(o){
			if (o.stIndex == undefined || ! o.onclick){
				return;
			}
			if ('string'==typeof o.stIndex){
				o.stIndex = this.f2stI(o.stIndex);
				if (o.stIndex < 0){
					return;
				}
			}
			if (! o.text){
				o.text = '导入';
			}
			if (! o.key){
				o.key = 'T';
			}
			if (! o.name){
				o.name = 'autoCreate';
			}
			if (! o.bg || ! o.img){
				o.img = 'copy';
			}
			var bn = o.name + o.stIndex;
			var buttonBox = jQuery('#div' + o.stIndex + 'button');
			var button = '8' == this.ev
			    ? ('<button class="addbtn_p" type="button"'
			    	+ ' style="background: url('+(o.bg ? o.bg
			    		: '/wui/theme/ecology8/jquery/js/button/'+o.img+'_wev8.png')+') no-repeat"'
				    + ' id="$'+bn+'$" name="'+bn+'" onclick="'
				    + o.onclick+'" title="'+o.text+'"></button>')
				: ('<button name="' + bn + '" class="BtnFlow"'
					+ ' id="$' + bn + '$" accessKey="' + o.key + '"'
					+ ' onclick="' + o.onclick + '" type="button">'
					+ '<u>' + o.key + '</u>'
					+ '-' + o.text
					+ '</button>')
				;
			buttonBox.html(button + buttonBox.html());
		}
/**
{
	Desc : 'Open Browser | 打开对话浏览框'
	,Params : {
		Option : Object
		,Example : {
			page : 'Browser Page URL , String'
			,height : 'Browser Height , String' (M Default : 550px)
			,width : 'Browser Width , String' (M Default : 550px)
			,f : 'Browser Field , String' (M)
		}
		,Value Operation : Function
	} 
	,Return : Page Return Value(Ecology 7 Only)
}
 */
		,ob : function(o , f){
			if (! o.page){
				return;
			}
			if (! o.height){
				o.height = '550px';
			}
			if (! o.width){
				o.width = '550px';
			}
			if (true
			&& '8' == this.ev 
			&& top.Dialog ){
				var d = new top.Dialog();
//				d.Title = '';
				d.Width = this.n(o.width, 550, true);
				d.Height = this.n(o.height, 550, true);
				d.Drag = true;
				d.maxiumnable = true;
				d.URL = o.page;
				d.callbackfun = function(p1,r,p3){
					if (o.f && r){
						var rv = function(k){
							if (! k in r){
								return;
							}
							var s = r[k];
							return s.indexOf(",") == 0 ? s.substring(1) : s;
						};
						_C.v(o.f , rv('id'));
						_C.t(o.f , rv('name'));
					}
					if (!!r 
					&& 'function' == typeof f){
						f(r);
					}
				};
				d.show();
			} else {
				var r = window.showModalDialog(o.page , undefined
					,'dialogHeight:' + o.height + ';'
					+ 'dialogWidth:' + o.width + ';'
					+ 'center:yes;menubar:no');
				if (o.f && r){
					var rv = function(k){
						if (! k in r){
							return;
						}
						var s = r[k];
						return s.indexOf(",") == 0 ? s.substring(1) : s;
					};
					_C.v(o.f , rv('id'));
					_C.t(o.f , rv('name'));
				}
				if (!!r 
				&& 'function' == typeof f){
					f(r);
				}
				return r;
			}
		}
/**
{
	Desc : 'Browser Button | 浏览按钮图标'
	,Params : {
		Field ID : String
		,Button Click Function : Function (M Override)
	} 
	,Return : Browser Button (JQuery Object)
}
 */
		,browserButton : function(id , f){
			var b = jQuery('#' + id).siblings('button:first');
			if ('function' == typeof f){
				for (var k = 0; k < b.length; k++){
					b[k].onclick = f;
				}
			}
			return b;
		}
/**
{
	Desc : 'Delete Row | 删除行'
	,Params : {
		Sub Table Index : Int
		,Row Index : Int Or String('_?') (M Delete All)
	} 
}
 */
		,deleteRow : function(stI , rI){
			if ('string'==typeof stI){
				stI = this.f2stI(stI);
				if (stI < 0){
					return;
				}
			}
			var _c = this;
			var cs = document.getElementsByName('check_node_' + stI);
			if (cs.length < 1){
				cs = document.getElementsByName('check_mode_' + stI);
				if (cs.length < 1){
					return;
				}
			}
			var n = -1;
			if (rI){
				n = 
					_c.n(rI
					, _c.n(rI.substring(1) 
						, -1
						, true), true);				
			}
			for (var k = 0; k < cs.length; k++){
				if (rI && n != _c.n(cs[k].value, -2, true)){
					continue;
				}
				cs[k].checked = 'checked';
			}
			var oldDialog = window.isdel;
			window.isdel = function(){return true;};
			eval('deleteRow' + stI + '(' + stI + ')');
			window.isdel = oldDialog;
		}
/**
{
	Desc : 'Add Row | 增加行'
	,Params : {
		Sub Table Index : Int
		,Data Action : Function (Param : Row Number)
	} 
}
 */
		,addRow : function(stI , f){
			if (undefined == stI){
				return;
			}
			if ('string'==typeof stI){
				stI = this.f2stI(stI);
				if (stI < 0){
					return;
				}
			}
			var n = '_' + $G('indexnum' + stI).value;
			eval('addRow' + stI + '(' + stI + ');');
			if (f){
				this.emst(stI, n, function(){
					f(n);
				});
			}
		}
/**
{
	Desc : 'Top Menu | 顶部菜单附加'
	,Params : {
		Menu Action : Function
		,Text : String (M Default '菜单X')
		,Img : String (M Default 'btn_list')
	} 
}
 */
		,topMenu : function(f , text , img){
			if(! window.parent.bar){
				return;
			}
			if (! f){
				return;
			}
			var mBox = jQuery('#toolbarmenu', window.parent.document);
			var id = mBox.children('td').length+1;
			if (! text){
				text = '菜单' + id;
			}
			if (! img){
				img = 'btn_list';
			}
			var key = 'menuItemDivId' + id;
			var bar_ = window.parent.bar;
			var m = {
				id: key
				, text: text
				, iconCls: img
				, handler: f
			};
			window.parent.bar = [m];
			window.parent.setToolBarMenu();
			bar_ = bar_.push(m);
			var t = jQuery('button:contains("'+text+'")'
					, mBox).parents('table:first').onclick = f;
		}
/**
{
	Desc : 'More Menu | 右键菜单附加'
	,Params : {
		Menu Action : Function
		,Text : String (M Default '菜单X')
	} 
}
 */
		,moreMenu : function(f , text){
			if (! f){
				return;
			}
			var mBox = jQuery('div[id="menuTable"]'
				, window.frames['rightMenuIframe'].document);
			var n = mBox.children('.b-m-item').length+1;
			if (! text){
				text = '菜单' + n;
			}
			var theme = window.parent.GLOBAL_CURRENT_THEME || 'ecology7';
			var folder = window.parent.GLOBAL_SKINS_FOLDER || 'default';
			var id = 'menuItemDivId' + n;
			var m = '<div id="' + id + '"'
				+ ' class="b-m-item"'
				+ ' onmouseover="this.className=\'b-m-ifocus\'"'
				+ ' onmouseout="this.className=\'b-m-item\'"'
				+ ' unselectable="on" >'
				+ '<div class="b-m-ibody" unselectable="on" >'
				+ '<nobr unselectable="on" >'
				+ '<img align="absMiddle"'
				+ ' src="/wui/theme/'
				+ theme
				+ '/skins/'
				+ folder
				+ '/contextmenu/default/11.png"'
				+ ' width="16" >'
				+ '<button id="'
				+ id
				+ '_btn" style="width: 120px" >'
				+ text
				+ '</button>'
				+ '</nobr></div></div>';

			mBox.append(jQuery(m));
			jQuery('#rightMenuIframe')
				.height(jQuery('#rightMenuIframe').height()+24);
			jQuery('#'+id+'_btn', mBox).bind('click', f);
		}
/**
{
	Desc : 'Post Ajax | Post Ajax'
	,Params : {
		URL : String
		,Function : Result Param
	} 
}
 */
		,post : function(url , f){
			jQuery.ajax({
				type : 'post'
				, url : url
				, success : f
			});
		}
/**
{
	Desc : 'To JSON | 字符串转JSON'
	,Params : {
		JSON String : String
		,Function : Error Function
	} 
}
 */
		,json : function(s , f){
			try {
				return eval('(' + s + ')');
			} catch (e) {
				if (f){
					f(e);
				}
			}
		}
/**
{
	Desc : 'URL Parameter | 获取地址栏参数'
	,Params : {
		Parameter Key : String (Return Parameter Of Key)
		,Default Value : String (M)
	} 
	,Return : Parameters
}
 */
		,uP : function(key , dv){
			var url = window.location.href;
			if (url.indexOf('?') < 0){
				return key ? dv : {};
			}
					
			var s = url.substring(url.indexOf('?') + 1).split('&');
			var p = {};
			for (var n = 0; n < s.length; n++){
				var t = s[n].split('=');
				var k = t[0];
				var v = t[1];
				if (k in p){
					if (p[k] instanceof String){
						var ks = p[k];
						var a = [];
						a[0] = ks;
						a[1] = v;
						p[k] = a;
					} else {
						var a = p[k];
						a[a.length] = v;
						p[k] = a;
					}
				} else {
					p[k] = v;
				}
			}
			if (key){
				return p[key];
			} else {
				return p;
			}
		}
/**
{
	Desc : 'Is Read Only | 流程是否只读'
	,Return : {
		True : Is Read Only
		,False : Editing
	}
}
 */
		,isRead : function(p){
			if (! p){
				p = this.uP();
			}
			if ('reEdit' in p){
				return false;
			}
			if ('message' in p){
				return false;
			}
			if ('requestid' in p){
				return true;
			}
			return false;
		}
/**
{
	Desc : 'Map Show | 遍历集合字符'
	,Params : {
		Map : Object
		,Title : String (M)
	} 
	,Return : Map Key And Values
}
 */
		,mapShow : function(o , t){
			if (! o){
				return;
			}
			if (! t){
				t = 'Map';
			}
			var s = t + ' : \n{';
			var f = true;
			for (var k in o){
				s = s + '\n   ' + (f ? ',' : ' ') + k + ' : ' + o[k];
				f = false;
			}
			s = s + '\n}';
			return s;
		}
/**
{
	Desc : 'Only One Check | 有且只有其一'
	,Params : {
		Target Field : String
		,All Field : String[]
		,Row Index : Int Or String('_?') (M Delete All)
	} 
}
 */
		,onlyOne : function(t , mf , r){
			var _c = this;
			if (_c._onlyOneRunning){
				return;
			}
			_c._onlyOneRunning = true;
			try {
				if (! t || ! mf){
					return;
				}
				if (! r){
					r = '';
				} else if (_c.n(r, -1, true) > -1){
					r = '_' + r;
				}
				if ('' == _c.v(t+r)){
					var nv = true;
					for (var k = 0; k < mf.length; k++){
						if (mf[k] == t){
							continue;
						}
						var fk = mf[k]+r;
						if ('' != _c.v(fk)){
							if (nv){
								nv = false;
							} else {
								_c.vt(fk, '');
							}
						}
					}
					if (nv){
						for (var k = 0; k < mf.length; k++){
							var fk = mf[k]+r;
							_c.rs(fk, true);
						}
					}
				} else {
					for (var k = 0; k < mf.length; k++){
						if (mf[k] == t){
							continue;
						}
						var fk = mf[k]+r;
						_c.rs(fk, false);
						_c.vt(fk, '');
					}
				}
			} catch (e) {}
			_c._onlyOneRunning = false;
		}
		,_onlyOneRunning : false
/**
{
	Desc : 'A Label For Hrm | 人力资源链接'
	,Params : {
		Hrm Resource ID Value : String
		,Hrm Resource Last Name Text : String
	} 
	,Return : A Label HTML
}
*/
		,aHrm : function(v , t){
			return '<a onclick="pointerXY(event);"'
				+ ' href="javascript:openhrm(' + v + ');">'
				+ t + '</a>';
		}
/**
{
	Desc : 'Editer Display | 编辑区显示切换(E8)'
	,Params : {
		Field ID : String
		,Is Display : Boolean
	}
}
*/
		,editerDisplay : function(id , isDisplay){
			var _c = this;
			if (jQuery('button#'+id+'browser').length){
				if (isDisplay){
					jQuery('button#'+id+'browser').show();
				} else {
					jQuery('button#'+id+'browser').hide();
				}
			} else if (jQuery('#'+ id + '_browserbtn').length){
				window.setTimeout(function(){
					var _jp = jQuery('#'+ id + 'span').parents('div.e8_os');
					if (isDisplay){
			            jQuery('#'+ id + 'span_crivia').hide();
			            _jp.show();
			            //jQuery('#'+ id + '_browserbtn').show();
			            //jQuery('#'+ id + 'span').parent().parent().show();
					} else {
			            if (! jQuery('#'+ id + 'span_crivia').length){
			                _jp.parent().append(
'<span id="'+id+'span_crivia" style="float: left;" ></span>');
			            }
			            //jQuery('#'+ id + '_browserbtn').hide();
			            //jQuery('#'+ id + 'span').parent().parent().hide();
			            _jp.hide();
			            jQuery('#'+ id + 'span_crivia').html(_c.t(id));
			            jQuery('#'+ id + 'span_crivia').show();
			            jQuery('#'+ id + 'span_crivia').find('span.e8_delClass').hide();
					}
				} , 370);
			} else {
				var o = jQuery('#'+ id);
				if (jQuery(o).attr('type') == 'hidden'){
					return;
				}
				var s = o.find('option:selected');
				if (isDisplay){
		            jQuery('#'+ id + 'span_crivia').hide();
					if (_c.ui.isMobile() && s.length){
						jQuery('input[id$="' + id +'"]').show();
					} else {
						o.show();
					}
					if (! s.length){
						if (_c.v(id)){
							_c.t(id , '');
						}
					}
				} else {
					if (_c.ui.isMobile() && s.length){
						jQuery('input[id$="' + id +'"]').hide();
					} else {
						o.hide();
					}
					if (s.length){
						var x = s.text();
						var t = jQuery('#'+ id + 'span_crivia');
			            if (! t.length){
			                var p = o.parent();
			                p.prepend( '<span id="'+id+'span_crivia" style="float: none;" ></span>');
			            }
						t = jQuery('#'+ id + 'span_crivia');
			            t.html(o.val()?x:'');
			            t.show();
					} else {
						if (_c.v(id)){
							var t = document.getElementById(id + 'span');
							if (!t){
				                var p = o.parent();
				                p.append('<span id="'+id+'span" style="float: none;" ></span>');
							}
							_c.t(id , _c.v(id));
						}
					}
				}
			}
		}
/**
{
	Desc : 'Edit Mobile Sub Table  | 编辑移动端子表'
	,Params : {
		Sub Table Index : Int Or String(Field)
		,Row Index : Int Or String('_?') 
		,Function : Edit Action
	}
}
*/
		,emst : function(stI , rI , f){
			if ('function'!=typeof f){
				return;
			}
			if (stI < 0){
				f();
				return;
			}
			if ('string'==typeof stI){
				this.emst(this.f2stI(stI), rI, f);
				return;
			}
			if ('function'!=typeof window.detailTrClick){
				f();
				return;
			}
			var _c = this;
			var n = -1;
			if (rI){
				n = 
					_c.n(rI
					, _c.n(rI.substring(1) 
						, -1
						, true), true);				
			}
			if (n < 0){
				return;
			}
			if ('function'!= typeof this._v){
				this._v = this.v;
				this.v = function(id , v){
					var o = this._v(id, v);
					if ('object'!=typeof o){
						return o;
					}
					var e = jQuery('#'+id+'_d');
					if (!e.length
					|| 'string'!= typeof e.attr('onchange')
					|| e.attr('onchange').indexOf('dynamicModify')<0){
						return;
					}
					e.val(v);
					e.change();
				};
			}
			var ea = jQuery('#trEdit_'+stI+'_'+n);
			if (ea.length > 0){
				f();
				var fo = document.activeElement;
				var tagName = fo.tagName;
				fo = jQuery(document.activeElement);
				var id = fo.attr('id');
				var name = fo.attr('name');
				var value = fo.val();
				try {
					window.detailTrClick(stI , n);
					window.detailTrClick(stI , n);
				} catch (e) {}
				var fo = id ? jQuery(tagName+'[id="'+id+'"]')
					: jQuery(tagName+'[name="'+id+'"]');
				fo.focus();
				fo.val(value);
				return;
			}
			try {
				window.detailTrClick(stI , n);
			} catch (e) {}
			f();
			try {
				window.detailTrClick(stI , n);
			} catch (e) {}
		}
/**
{
	Desc : 'Field To Sub Table Index  | 字段子表索引'
	,Params : Field(String)
	,Return : Sub Table Index(Int)
}
*/
		,f2stI : function(f){
			if (f in this._m4f2stI){
				return this._m4f2stI[f];
			}
			var o = jQuery('#'+f).parents('table[id^="oTable"]');
			if (o.length > 0){
				o = o.attr('id');
				if ('string'==typeof o){
					o = _C.n(o.substring(6),-1,true);
					this._m4f2stI[f] = o;
					if (o > -1){
						return;
					}
				}
			}
			this._m4f2stI[f] = -1;
			return this.f2stI(f);
		}
		,_m4f2stI : {}
/**
{
	Desc : 'Reset Browser Page | 重写浏览按钮打开页面(E8)'
	,Params : {
		Field ID : String
		,Page URL : String
		,Parameter Loader : Function
	}
}
*/
		,rbp : function(id , url , parameterLoader){
			var jo = jQuery('#'+id+'_browserbtn');
			if (! jo.length){
				return;
			}
			var btn = jo[0];
			var onclicks = btn.getAttribute('onclick').split(',');
			btn.onclick = function(){
				var s = '';
				for (var k = 0; k < onclicks.length; k++){
					if (0 < k){
						s += ',';
					}
					if (1 == k){
						var p = '';
						if ('function'==typeof parameterLoader){
							var o = parameterLoader();
							if ('string'==typeof o){
								p = o;
							}
						}
						s += '\''+url+p+'&__f=\'';
					} else if (4 == k) {
						var b = onclicks[k].substring(0,onclicks[k].indexOf('.'));
						var e = onclicks[k].substring(onclicks[k].indexOf('.'));
						if (b.match(/field\d+_?\d?/)){
							s += 'document.getElementById(\''
								+ b + '\')' + e;
						} else {
							s += onclicks[k];
						}
					} else {
						s += onclicks[k];
					}
				}
				eval(s);
			};
		}
/**
{
	Desc : 'Editer Status Switch | 控件状态切换'
	,Params : {
		Field ID : String
		,Editable & Requird : Boolean
	} 
}
*/
		,ess : function(f , ss){
			if (! ss){
				this.editerDisplay(f, true);
				this.v(f, '');
			}
			this.rs(f, !!ss);
			this.editerDisplay(f, !!ss);
		}
		,_fkReady : []
		,_fkReadyRun : function(){
			if (!!window.t0){
				for (var k = 0; k < this._fkReady.length; k++){
					this._fkReady[k]();
				}
				return;
			}
			window.setTimeout('_C._fkReadyRun()',100);
		}
/**
{
	Desc : 'Field Key Ready | 字段信息就绪'
	,Params : {
		Function : Do Something When Fields Ready
	} 
}
*/
		,fkReady : function(f){
			if ('function'!=typeof f) return;
			if (!!window._CriviaDymanicFields
			&& !!window._CriviaDymanicFields.length) {
				f(); return;
			}
			var n = this._fkReady.length;
			if (0 == n){
				this._fkReadyRun();
			}
			this._fkReady[n] = f;
		}
};
GlobalReger(function(w){
	w.CriviaWorkFlowJavaScriptFunctions = top.CriviaWorkFlowJavaScriptFunctions;
});

top._C = CriviaWorkFlowJavaScriptFunctions==top._C
	?top._C:CriviaWorkFlowJavaScriptFunctions;
GlobalReger(function(w){
	w._C = top._C;
});
top._CRM = undefined!=top._CRM?top._CRM:_C._cwjsListenerValueMap;
GlobalReger(function(w){
	w._CRM = top._CRM;
});
































