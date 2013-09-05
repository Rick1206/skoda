(function($){

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
            function expertLinkHover(i,direction){
                var direction = direction == "on" ? 0:1;
                itemCarousel.eq(i).trigger('currentPage',function(a){
                    $('li',this).find('img').eq(direction).fadeOut().siblings('img').fadeIn();
                });
            }
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

            $('.btn-share').on('mouseenter',function(){
                $(this).siblings('.share-bar').show(),
                $(this).addClass('selected');
            }).parent('.share').on('mouseleave',function(){
                    $(this).find('.share-bar').hide(),
                    $(this).find('.btn-share').removeClass('selected');
                });

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
            $('a',gotop).on('click',function(){
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
        })();

        // 'get more data'  for example
        $('.btn-getmore-idea').length ==1&&(function(){
            $('.btn-getmore-idea').on('click',function(){
                $('.ideas-bd').children().slice(1).clone(true).appendTo($('.ideas-bd'))
            });
        })();
})(window.jQuery);