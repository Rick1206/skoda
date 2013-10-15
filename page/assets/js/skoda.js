(function($){

    //notification
      $('.usr').mouseover(function(){
      	$(this).addClass('open');
      });
      
       $('.usr').mouseout(function(){
      	$(this).removeClass('open');
      });
    
    // Index top carousel;
    $('.expert-carousel').length==1&&
        (function(){
            var itemCarousel = $('.expert-carousel .item-carousel');
            var itemCarouselPagination = $('.expert-carousel-pagination');
            var expertLink= $('#expert-link a');
            var c_timer = 1000;
            itemCarousel.each(function(i){
                $(this).carouFredSel({
                    responsive  : true,
                    items:{
                        visible : 1,
                        width:130
                    },
                    auto:{
                        timeoutDuration:5000
                    },
                    scroll:{
                        fx:'none',
                        onAfter:function($Carousel){
                            $Carousel.items.visible.hide().end().fadeIn(c_timer);
                            expertLink.eq(i).attr('href',$Carousel.items.visible.data('href'));
                        }
                    },
                    onCreate:function($Carousel){
                        expertLink.eq(i).attr('href',$Carousel.items.data('href'));
                    },
                    pagination:{
                        container:'.expert-carousel-pagination',
                        anchorBuilder:function(nr){
                            return '<a href="javascript:void(0)" class="btn-controller-expert"></a>'
                        }
                    }
                });
            });

            itemCarouselPagination.find('a').each(function(i){
                $(this).on('click',{i:i},itemTarget);
            });

            function itemTarget(e){
                itemCarousel.each(function(){
                    $(this).trigger('slideToPage',e.data.i);
                })
            };

            expertLink.each(function(i){
                $(this).on('mouseenter',function(){
                    expertLinkHover(i,'on');
                })
                $(this).on('mouseleave',function(){
                    expertLinkHover(i,'out');
                })
            });

            $('.expert-mask').hover(itemCarouselPause,itemCarouselPlay);

            function expertLinkHover(i,direction){
                var direction = direction == "on" ? 0:1;
                itemCarousel.eq(i).trigger('currentPage',function(a){
                    $('li',this).find('img').eq(direction).stop(false,true).fadeOut().siblings('img').stop(false,true).fadeIn();
                });
            };

            function itemCarouselPause(){
                itemCarousel.each(function(){
                    $(this).trigger('pause');
                })
            };
            function itemCarouselPlay(){
                itemCarousel.each(function(){
                    $(this).trigger('play');
                })
            }
            //vertical center

            itemCarousel.find('img').each(function(){
                var $this = $(this);
                $this.css({visibility:'hidden'});
                $this.on('load',function(){
                    $this.css({
                        top:'50%',
                        marginTop:-$(this).height() *.5,
                        visibility:'visible'
                    });
                });

                var _pic = new Image();
                _pic.onload = function(){
                    $this.trigger('load');
                    _pic = null;
                }
                _pic.src = this.src;

            });
        })();

        //call-board2
        $('.call-board2-carousel').length ==1&&
        (function(){
            $('.call-board2-carousel').carouFredSel({
                width:406,
                height:240,
                auto:{
                    timeoutDuration:5000
                },
                pagination:{
                    container:'.call-board2-pagination',
                    anchorBuilder:function(nr){
                        return '<a href="#'+nr+'" class="btn-controller-callBoard2"></a>';
                    }
                }
            });
        })();

        //share bar
        $('.btn-share').length>=1&&
        (function(){
            $('.btn-share').each(function(){
                if(!$(this).hasClass('disable')){
                    $(this).on('mouseenter',function(){
                        $(this).siblings('.share-bar').show(),
                            $(this).addClass('selected');
                    }).parent('.share').on('mouseleave',function(){
                            $(this).find('.share-bar').hide(),
                                $(this).find('.btn-share').removeClass('selected');
                        });
                };
            })



        })();
        //maessage popup
        $('.JsPopMessage').length>=1&&
        (function(){

            $('.JsPopMessage').find('.message').on('click',function(){
                var $this = $(this);
                $this.siblings('.message-popup').show().end().addClass('selected');
                $(document).on('click',function(e){
                    if($this.parent('.JsPopMessage').find(e.target).length==0){
                        $this.siblings('.message-popup').hide().end().removeClass('selected');
                    }
                });
            }).end().find('.close').on('click',function(){
                    var popbox = $(this).parent();
                    popbox.hide(),popbox.siblings('.message').removeClass('selected');
                });


        })();

		//goback document top
        $('#gotop').length==1&&(function(){
            var gotop = $('#gotop');
            var _h ,_foot_h;
            gotop.on('click',function(){
                $(window).scrollTop(0);
            });
            $(window).resize(function(){
                _h = $(window).height()-gotop.height();
                _foot_h = $('footer').height();
                $(this).scroll();
            }).resize();
            $(window).scroll(function(e){
                var x = $('footer').position().top-$(window).scrollTop()-$(window).height();
                if($(window).scrollTop()+$(window).height()>$(document).height()-_foot_h){
                    gotop.css('top',_h+x);
                    //console.log("yes");
                }else if($(window).scrollTop()==0){
                    gotop.css('top',$('document,body').height());
                }else{
                    gotop.css('top',_h);
                }
               // console.log( _h,x);
            });


            // 'get more data'  for example
            $('.btn-getmore-idea').length ==1&&(function(){
                $('.btn-getmore-idea').on('click',function(){
                    $('.ideas-bd').children().slice(1).clone(true).appendTo($('.ideas-bd'));
                    $(window).resize();
                });
            })();
        })();
        
        //ctp-idea-name
        
        $(".ctp-idea-item-name").length>0 && (function(){
           $(".ctp-idea-item-name").each(function(){
        		var ctpItemName  =  $(this);
	        	var ctpContent = $.trim(ctpItemName.html());
	        	var introLen = ctpItemName.attr("maxlength");
	        	if(ctpContent.length>introLen){
	        		var subContent = ctpContent.substr(0,introLen)+"...";
	        		ctpItemName.html(subContent);
	        	}
        	});
        })();
        
        
        //ctp-message-content
         $(".ctp-message-content").length>0 && (function(){
         	$('.ctp-message-content').focusin(function(){
	    		 if($(this).val() == "写下您的评论..."){
	    		 		$(this).val("");
	    		 	}
	    		 });
	    		  
	    		 $('.ctp-message-content').focusout(function(){
	    		 	if($(this).val() == ""){
	    		 		$(this).val("写下您的评论...");
	    		 	}
	    		 });
        })();
        

        $('.text-wrap').length >=1 && (function(){
            $('.text-wrap').jScrollPane({showArrows: true,autoReinitialise: true,contentWidth: '0px'});
        })();

        $('.jsPopIdeaDetail').click(function(){
            $('.pop-idea-detail').bPopup({
                follow: [true,false],
                position:['auto',100]
            });
        });
        
        $('.default-update-info').click(function(){
        	 $('.pop-idea-detail').bPopup().close();
			 location.hash = 'bpop-profile-form';
                if(br_ver.indexOf('msie 7')||br_ver.indexOf('msie 6')){
                    $(window).trigger('hashchange');
                }
        });
     
		var trig = true;
		var test_notification_ele = $('.notification .text-wrap').find('ul').html();
		
        $('.notification .text-wrap').on('jsp-scroll-y',function(event, scrollPositionY, isAtTop, isAtBottom){
            if(isAtBottom && trig){
            	trig = false;
            	loadContent($(this));  
            }
        });
		
		function loadContent(scroll){
			var api = scroll.data('jsp');
			api.getContentPane().append(test_notification_ele);
			api.reinitialise();
			//-- ajax callback set trig true --// 
			setTimeout(function(){trig=true;},800);
		}
		
        //get more data'  for example
        $('.suggestions').length>0&&(function(){
            var $suggestions =  $('.suggestions');
            var $suggestions_list = $suggestions.find('.suggestions-list');
            var element_example = $suggestions_list.find('li');
            $('.btn-more2',$suggestions).click(function(){
                element_example.clone(true).appendTo($suggestions_list);
                bgfix();
            });
            $(window).scroll(function(){
                if( $(this).scrollTop() == $(document).height()-$(this).height()){

                    if($suggestions_list.find('li').length<15){
                        $('.btn-more2',$suggestions).click();
                    };
                    if($suggestions_list.find('li').length==15){
                        $(window).off('scroll');
                    }
                }
            });
            
            $(document).on('click','.suggestions .against',function(){
                var $this = $(this);
                if($(this).data('reported')!=1){
                    $(this).siblings('.pos-text').append('<span style="padding-left: 10px;color: red">已举报</span>');
                    $(this).data('reported',1).hide();
                }
                return false;
            });
            
            $(document).on('click','.suggestions .delete',function(){
                var $this = $(this);
                $.confirm('确认删除吗?',function(result){
                    if(result){
                        $this.parent('li').remove();
                        bgfix();
                    }
                });
                return false;
            });
            
            bgfix();
            
            function bgfix(){
                var $page = $('#page');
                var fixMask = $('.body-background-profile-fixed');
                if($page.height()>=1200){
                    fixMask.css({
                        height:($page.height()-1200)<30?0:($page.height()-1200)
                    })
                }
            }

            var suggestionsInput = $('#suggestions-input');
            $('#suggestions-submit').click(function(){
            	var textLen = parseInt(suggestionsInput.val().length);
            	var limitWords = parseInt(suggestionsInput.attr("maxlength"));
            	var errorMsg = $(".suggestions-error");
                if(textLen == 0) return false;
                if(textLen > limitWords){
                	var overNum = textLen - limitWords;
                	errorMsg.html("已超出"+overNum+"字");
                	return false;
                }else{
                	errorMsg.html("");
                }
                var ele = element_example.eq(1).clone(true);
                ele.find('.type-middle').html(suggestionsInput.val());
                ele.find('.time').html('刚刚');
                $suggestions_list.prepend(ele);
                suggestionsInput.val(""),bgfix();
                return false;
            });

			
        })();

        $.confirm = function(title,callback){
            var title = title || '';
            var callback = callback ;
            var confirm =  false;
            var popbox = $('<div class="confirm"><p class="title">'+title+'</p><a href="#" class="btn-yes"></a><a href="#" class="btn-no"></a></div>');
            popbox.find('.btn-yes').click(function(){
                confirm= true;
                popbox.bPopup().close();
                return false;
            });
            popbox.find('.btn-no').click(function(){
                confirm= false;
                popbox.bPopup().close();
                return false;
            })
            $('body').append(popbox);
            popbox.bPopup({
                modalClose: false,
                fadeSpeed: 'fast',
                positionStyle: 'fixed',
                onClose:function(){
                    popbox.remove();
                    callback.call(this,confirm);
                }
            });
        };
        $.alert = function(title){
            var title = title || '';
            var callback = callback ;
            var confirm =  false;
            var popbox = $('<div class="alert"><p class="title">'+title+'</p><a href="#" class="btn-affirm"></a></div>');
            popbox.find('.btn-affirm').click(function(){
                popbox.bPopup().close();
                return false;
            });
            $('body').append(popbox);
            popbox.bPopup({
                modalClose: false,
                fadeSpeed: 'fast',
                positionStyle: 'fixed',
                onClose:function(){
                    popbox.remove();
                }
            });
        }
        
        //  upload
        $('.pop-upload-box').length>0&&(function(){

           var $box = $('.pop-upload-box');
           
            window.closePanel = function() {
				$('.pop-upload-box').bPopup().close();
			}
            
            window.uploadPhotoComplete1 = function(receivedData) {
				alert("Received Data is " + receivedData);
				closePanel();
			}
            
            var flashvars = {
					uploadURL:"/function_all/index.php",
					callbackCompleteFunction:"uploadPhotoComplete1"
				};
				
			var params = {
					menu: "false",
					scale: "noScale",
					allowFullscreen: "true",
					allowScriptAccess: "always",
					bgcolor: "",
					wmode: "transparent"
				};
            
            $('.jsPopUploadBox').click(function(){
                $box.bPopup({
                	onOpen:function(){	
                	setTimeout(
	                    function(){
			                swfobject.embedSWF(
								"assets/swf/upload.swf", 
								"altContent", "340", "159", "10.3.0", 
								"assets/swf/expressInstall.swf", 
								flashvars, params
							);
	                    },300);
                	},
                	onClose:function(){
                		$box.html("<div id='altContent'></div>");
                }});
            });
			
        })();
        
        
        // ctp-user-intro
        $(".ctp-user-intro").length>0&&(function(){
        	var ctpIntro =  $(".ctp-user-intro p");
        	var ctpContent=  $.trim($(".ctp-user-intro p").html());
        	var introLen =  $(".ctp-user-intro p").attr("maxlength");
        	if(ctpContent.length>introLen){
        		var subContent = ctpContent.substr(0,introLen)+"...";
        		ctpIntro.html(subContent);
        	}
        })();
        
        //ctp-user-name
        $(".ctp-user-name").length>0&&(function(){
        	var ctpUname  =  $(".ctp-user-name");
        	var ctpContent = $.trim(ctpUname.html());
        	var introLen = ctpUname.attr("maxlength");
        	if(ctpContent.length>introLen){
        		var subContent = ctpContent.substr(0,introLen)+"...";
        		ctpUname.html(subContent);
        	}
        })();
        
        $(".ctp-comment-name").length>0&&(function(){
        	$(".ctp-comment-name").each(function(){
        		var ctpCname  =  $(this);
	        	var ctpContent = $.trim(ctpCname.html());
	        	var introLen = ctpCname.attr("maxlength");
	        	if(ctpContent.length>introLen){
	        		var subContent = ctpContent.substr(0,introLen)+"...:";
	        		ctpCname.html(subContent);
	        	}
        	});
        })();
        
        
        $('.pop-profile-form').length>0&&(function(){
            var $form = $('.pop-profile-form');
            var br_ver = navigator.appVersion.toLowerCase();
            $('.jsPopProfileForm').click(function(){
                location.hash = 'bpop-profile-form';
                if(br_ver.indexOf('msie 7')||br_ver.indexOf('msie 6')){
                    $(window).trigger('hashchange');
                }
            });

            $(window)
                .resize(function(){
                    $form.css('left',($(this).width()-775) *.5);
                })
                .on('hashchange',function(){
                    if(location.hash == '#bpop-profile-form'){
                        $form.bPopup({
                            follow: [true,false],
                            position:['auto',0],
                            modalClose: false,
                            onClose:function(){
                                removeHash();
                                $form.find('input[type=reset]').click();
                                $form.find('.error').removeClass('error');
                            }
                        });
                    }
                })
                .trigger('hashchange');

            function removeHash () {
                var loc = window.location;
                if ("pushState" in history)
                    history.pushState("", document.title, loc.pathname + loc.search);
                else {
                    loc.hash = "";
                }
            }

            $('.cars',$form).jScrollPane({autoReinitialise: true}).find('li').click(function(){
                $(this).toggleClass('selected');
            }).end().on('mousedown',function(){
                    $(this).removeAttr('tabindex');
                });


            $('.student',$form).change(function(){
                var $this = $(this);
                if($this.is(':checked')){
 	                   $.alert('在此确认,本人若最终获奖,将选择获得"学子特别奖",同时放弃“2013年度聪明达人”奖。具体内容,<a href="./tnc.html#student" target="_blank">查看这里</a>。<a class="b-close pop-close close-student" href="#"><span></span></a>');
                	$(".close-student").click(function(){
                		
                		$this.attr("checked",false);
                		
                	});
                }
            });
            
            
            //input-block-level 
            $(".input-block-level").length>0&&(function(){
        		 $('.input-block-level').focusin(function(){
        		 	if($(this).val() == "在此输入文字"){
        		 		$(this).val("");
        		 	}
        		 });
        		  
        		 $('.input-block-level').focusout(function(){
        		 	if($(this).val() == ""){
        		 		$(this).val("在此输入文字");
        		 	}
        		 });
        		 
        	})();
            
            //validate
            validate('#inputMobile','mobile');
            validate('#inputEmail','email');
            var validate_error = false;

            $('.J_user_bir_year,.J_user_bir_day').change(function(event) {
                _checkYearAndDay(false);
            });

            function _checkYearAndDay(isfocus){                
                var $year = $('.J_user_bir_year'),$day = $('.J_user_bir_day');
                var _vy = $year.val(),_vd = $day.val(),_regD = /\d{1,}/;

                if((_regD.test(_vy) && _regD.test(_vd)) || (!_regD.test(_vy) && !_regD.test(_vd))){

                }else{
                    if(!_regD.test(_vy)){ $year.addClass('error'); if(isfocus){$year.focus();} return false; }
                    if(!_regD.test(_vd)){ $day.addClass('error');if(isfocus){$day.focus();} return false; }
                }
                $('.J_user_bir_year,.J_user_bir_day').removeClass('error');
                return true;
            }


            $form.find('.btn-save').click(function(){

                if(_checkYearAndDay(true)){}else{ return false; }

                $('form',$form).find('.control-group').each(function(){
                    if($(this).hasClass('error')){
                        validate_error =  true;
                        return false;
                    }
                });
                
                var textArea =  $('form',$form).find('.input-block-level');
				var textAreaLen = parseInt(textArea.val().length);
				var errorMsg = $(".ctp-error-msg");
				var limitWords = parseInt(textArea.attr("maxlength"));
				
				if(textAreaLen>limitWords){
					var overNum = textAreaLen - limitWords;
					errorMsg.html("已超出"+overNum+"字");
					return false;
				}else{
					errorMsg.html("");
				}

                if(validate_error) return false;
            })
            function validate(ele,r){
                var reg = {
                    mobile : /^0*(13|15)\d{9}$/,
                    email :/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
                };
                $(ele).focusout(function(){
                    var _val = $(this).val();
                    var regx = reg[r] ;
                    if(regx.test(_val)||_val==""){
                        $(this).parents('.control-group').removeClass('error');
                    }else{
                        $(this).parents('.control-group').addClass('error');
                    }
                });
            }
        })();


		var vparams = {
			quality: "high",
			scale: "noscale",
			wmode: "window",
			allowscriptaccess: "always",
			bgcolor: "#FFFFFF",
			allowFullScreen:true
		};
		var vflashvars = {
		};
		var vattributes = {
		};
	
		//video popup
        $('.pop-video-box01').length>0&&(function(){
            $('.btn-3d-becomeTalent3').click(function(){
                $('.pop-video-box01').bPopup({
                    onOpen:function(){
                    	 var video = $(this).find('.video');
                        setTimeout(
                            function(){
                            	vflashvars={
                            		maxlength:5,
									xmlPath:"assets/xml/data.xml"
                            	}
							    swfobject.embedSWF(video.data('vid'), 
							    video.data('id'), "100%", "100%", "10.3.0",
							     "expressInstall.swf", vflashvars, vparams, vattributes);
                            },300
                        )
                    }
                });
                $(this).addClass('disable');
                $(this).off('click');
                return false;
            });
        })();

        $('.pop-video-box02').length>0&&(function(){
            $('.video-3d-men>a').click(popVideo2);

            var $popbox = $('.pop-video-box02');
            var domCache ;

            $popbox.find('.skip1').click(function(){
                $(this).parent('.step1').hide().siblings('.step2').show().end().remove();
            });

            function popVideo2(){
                $popbox.bPopup({
                    modalClose: false,
                    onOpen:function(){
                        domCache = $popbox.clone(true);
                        var video = $(this).find('.video');
                        setTimeout(
                            function(){   
                            	vflashvars={
                            		index:3,
                            		maxlength:5,
									xmlPath:"assets/xml/data.xml"
                            	}                           
                                swfobject.embedSWF(video.data('vid'), 
							    video.data('id'), "100%", "100%", "10.3.0",
							     "expressInstall.swf", vflashvars, vparams, vattributes);
                            },300
                        )
                    },
                    onClose:function(){
                        $popbox.replaceWith(domCache);
                        $popbox = $('.pop-video-box02');
                    }
                });
                return false;
            }
        })();

	//$('.pop-box').bPopup();

    function swf(d,a,b,eid){
        if (navigator.appName.indexOf("Microsoft") != -1) {
            return '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="'+a+'" height="'+b+'" id="'+eid+'" align="middle"><param name="movie" value="'+d+'" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /><param name="play" value="true" /><param name="loop" value="true" /><param name="wmode" value="transparent" /><param name="scale" value="showall" /><param name="menu" value="true" /><param name="devicefont" value="false" /><param name="salign" value="" /><param name="allowFullScreen" value="true" /><param name="allowScriptAccess" value="always" />';
        }else{
            return '<embed src="'+d+'" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" id="'+eid+'" name="'+eid+'" bgcolor="#000000" width="'+a+'" height="'+b+'" allowscriptaccess="always" quality="High" wmode="transparent" allowFullScreen="true"></object>';
        }
    };
    
   
	$(".message-box").length>0&&(function() {
		$(".btn-submit").click(function() {
			var textArea = $(this).parent().children("textarea");
			var textAreaLen = parseInt(textArea.val().length);
			var errorMsg = $(this).parent().children(".message-error");
			var limitWords = parseInt(textArea.attr("maxlength"));
			
			if(textAreaLen>limitWords){
				var overNum = textAreaLen - limitWords;
				errorMsg.html("已超出"+overNum+"字");
				return;
			}else{
				errorMsg.html("");
			}
			//-- ajax and so on--//
		});
	})();
	
   
})(window.jQuery);