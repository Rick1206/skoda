(function($){

    //notification
    $('.logined').click(function(){
        var target = $(this).parent('.usr');
        target.toggleClass('open');
        $(document).on('click',function(e){
            if($(e.target).parents('.usr').length ==0){
                target.removeClass('open');
            }
        });
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

//        goback document top
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
                if($(window).scrollTop()+$(window).height()>$('document,body').height()-_foot_h){
                    gotop.css('top',_h+x);
                }else if($(window).scrollTop()==0){
                    gotop.css('top',$('document,body').height());
                }else{
                    gotop.css('top',_h);
                }
            });


            // 'get more data'  for example
            $('.btn-getmore-idea').length ==1&&(function(){
                $('.btn-getmore-idea').on('click',function(){
                    $('.ideas-bd').children().slice(1).clone(true).appendTo($('.ideas-bd'));
                    $(window).resize();
                });
            })();
        })();

        $('.text-wrap').length >=1 && (function(){
            $('.text-wrap').jScrollPane({autoReinitialise: true,contentWidth: '0px'});
        })();

        $('.jsPopIdeaDetail').click(function(){
            $('.pop-idea-detail').bPopup({
                follow: [true,false],
                position:['auto',100]
            });
        });

        var test_notification_ele = $('.notification .text-wrap').find('ul').clone();

        $('.notification .text-wrap').on('jsp-scroll-y',function(event, scrollPositionY, isAtTop, isAtBottom){
            if(isAtBottom){
                $(this).find('.jspPane').append(test_notification_ele);
            }
        });


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
                if(suggestionsInput.val() =="") return false;
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
            var $form = $('#upload');
            var $form_file = $form.find('input[type=file]');
            $('.jsPopUploadBox').click(function(){
                $box.bPopup({
                    onClose:function(){
                        $box.find('.file-input').html('...');
                    }
                });
            });
            $form.ajaxForm(function(){
                alert('Upload succeed!');
            });
            $box.find('.btn-select-file').click(function(){
                $form_file.click();
            });
            $form_file.change(function(){
                $box.find('.file-input').html($(this).val());
            });

        })();
        $('.pop-profile-form').length>0&&(function(){
            var $form = $('.pop-profile-form');
            $('.jsPopProfileForm').click(function(){
                $form.bPopup({
                    follow: [true,false],
                    position:['auto',0],
                    modalClose: false,
                    onClose:function(){
                        $form.find('input[type=reset]').click();
                        $form.find('.error').removeClass('error');
                    }
                });
            })

            $(window).resize(function(){
                $form.css('left',($(this).width()-775) *.5);
            })
            $('.cars',$form).jScrollPane({autoReinitialise: true}).find('li').click(function(){
                $(this).toggleClass('selected');
            }).end().on('mousedown',function(){
                    $(this).removeAttr('tabindex');
                });


            $('.student',$form).change(function(){
                var $this = $(this);
                if($this.is(':checked')){
                    $.alert('在此确认,本人若最终获奖,将选择获得"学子特别奖",同时放弃“2013年度聪明达人”奖。具体内容,<a href="http://www.congmingzhuyi.com/how-to-play" target="_blank">查看这里</a>。');
                }
            });

            //validate

            validate('#inputMobile','mobile');
            validate('#inputEmail','email');
            var validate_error = false;

            $form.find('.btn-save').click(function(){

                $('form',$form).find('.control-group').each(function(){
                    if($(this).hasClass('error')){
                        validate_error =  true;
                        return false;
                    }
                });

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


//        video popup
        $('.pop-video-box01').length>0&&(function(){
            $('.btn-3d-becomeTalent3').click(function(){
                $('.pop-video-box01').bPopup();
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
                    },
                    onClose:function(){
                        $popbox.replaceWith(domCache);
                        $popbox = $('.pop-video-box02');
                    }
                });
                return false;
            }
        })();

    $('.pop-box').bPopup();


})(window.jQuery);