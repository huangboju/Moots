   var whetherrepeat = false;

    $("#img").attr("src", 'images/'+Math.floor(Math.random()*11)+'.jpg');

	$(function () {
		var Accordion = function (el, multiple) {
			this.el = el || {};
			this.multiple = multiple || false;

			// Variables privadas
			var links = this.el.find('.link');
			// Evento
			links.on('click', {el: this.el, multiple: this.multiple}, this.dropdown)
		}

		Accordion.prototype.dropdown = function (e) {
			var $el = e.data.el;
			$this = $(this),
					$next = $this.next();

			$next.slideToggle();
			$this.parent().toggleClass('open');

			if (!e.data.multiple) {
				$el.find('.submenu').not($next).slideUp().parent().removeClass('open');
			}
			;
		}

		var accordion = new Accordion($('#accordion'), false);


		// $("#mode").height($(".fa-1x").height()*1.5);
		$("#mode").width($(".fa-1x").width()*1.2);
		$("#mode").css('display','block');
        //
        // //

	});


    allmuisc = [{
        "album": "被禁忌的游戏(2004)", "music": [
            "被禁忌的游戏-黑色信封      ",
            "被禁忌的游戏-青春               ",
            "被禁忌的游戏-阿兰      ",
            "被禁忌的游戏-离婚               ",
            "被禁忌的游戏-欢愉      ",
            "被禁忌的游戏-卡夫卡               ",
            "被禁忌的游戏-被禁忌的游戏      ",
            "被禁忌的游戏-罗庄的冬天               ",
            "被禁忌的游戏-红色气球               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/3Black%20envelope.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/9Youth.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/1Alan.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/7divorce.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/5Joy.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/6Kafka.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/2The%20Forbidden%20Game.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/8Winter%20in%20Luozhuang.mp3",
                "http://www.youxinpc.com.cn/music/The%20Forbidden%20Game/4red%20balloon.mp3",

            ]
        },
        {
        "album": "梵高先生(2005)", "music": [
            "梵高先生-你离开了南京，从此没有人和我说话      ",
            "梵高先生-董卓瑶               ",
            "梵高先生-春末的南方城市      ",
            "梵高先生-广场               ",
            "梵高先生-来了      ",
            "梵高先生-暧昧               ",
            "梵高先生-想起了他      ",
            "梵高先生-梵高先生               ",
            "梵高先生-斜               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/You%20left%20Nanjing%20and%20no%20one%20spoke%20to%20me%20ever%20since.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/Dong%20Zhuoyao.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/Southern%20Cities%20at%20the%20End%20of%20Spring.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/square.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/Coming.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/ambiguous.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/Think%20of%20him.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/mr%20van%20gogh.mp3",
                "http://www.youxinpc.com.cn/music/Mr.%20Van%20Gogh/Oblique.mp3",

            ]
        },
        {
		    "album": "这个世界会好吗(2006)", "music": [
            "这个世界会好吗-妈妈      ",
            "这个世界会好吗-喀纳斯               ",
            "这个世界会好吗-和你在一起      ",
            "这个世界会好吗-我们不能失去信仰-献给刘艺               ",
            "这个世界会好吗-翁庆年的六英镑      ",
            "这个世界会好吗-他们               ",
            "这个世界会好吗-海的女儿      ",
            "这个世界会好吗-交河               ",
            "这个世界会好吗-这个世界会好吗&人民不需要自由&妈妈               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Mom.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Kanas.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Together%20with%20you.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/People%20do%20not%20need%20freedom.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Weng%20Qingnian's%20Six%20Pounds.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/they.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Hai's%20daughter.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Jiaohe.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/People%20do%20not%20need%20freedom.mp3",

            ]
		},
		{
		    "album": "工体东路没有人(2009)", "music": [
            "工体东路没有人-被禁忌的游戏      ",
            "工体东路没有人-和你在一起               ",
            "工体东路没有人-来了      ",
            "工体东路没有人-卡夫卡               ",
            "工体东路没有人-黑色信封      ",
            "工体东路没有人-阿兰               ",
            "工体东路没有人-春末的南方城市      ",
            "工体东路没有人-他们               ",
			"工体东路没有人-暧昧               ",
            "工体东路没有人-结婚      ",
            "工体东路没有人-这个世界会好吗               ",
            "工体东路没有人-红色气球      ",
            "工体东路没有人-月亮代表我的心               ",
            "工体东路没有人-董卓瑶      ",
            "工体东路没有人-青春               ",
            "工体东路没有人-想起了她               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Mom.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Kanas.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Together%20with%20you.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/People%20do%20not%20need%20freedom.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Weng%20Qingnian's%20Six%20Pounds.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/they.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Hai's%20daughter.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Jiaohe.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/People%20do%20not%20need%20freedom.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Together%20with%20you.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/People%20do%20not%20need%20freedom.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Weng%20Qingnian's%20Six%20Pounds.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/they.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Hai's%20daughter.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/Jiaohe.mp3",
                "http://www.youxinpc.com.cn/music/Will%20the%20world%20be%20all%20right/People%20do%20not%20need%20freedom.mp3",

            ]
		},
		{
		    "album": "二零零九年十月十六日事件(2009)", "music": [
            "十月十六日事件-黑色信封      ",
            "十月十六日事件-董卓瑶               ",
            "十月十六日事件-春末的南方城市      ",
            "十月十六日事件-来了               ",
            "十月十六日事件-广场      ",
            "十月十六日事件-青春               ",
            "十月十六日事件-他们      ",
            "十月十六日事件-被禁忌的游戏               ",
			"十月十六日事件-这个世界会好吗               ",
            "十月十六日事件-妈妈      ",
            "十月十六日事件-听妈妈讲过去的事情               ",
            "十月十六日事件-陀螺      ",
            "十月十六日事件-鸟语               ",
            "十月十六日事件-狐狸      ",
            "十月十六日事件-达摩流浪者               ",
			"十月十六日事件-结婚      ",
            "十月十六日事件-来自我心               ",
            "十月十六日事件-虎口脱险      ",
            "十月十六日事件-恋恋风尘               ",
			"十月十六日事件-倒影               ",
            "十月十六日事件-鸵鸟      ",
            "十月十六日事件-天空之城               ",
            "十月十六日事件-苍井空      ",
            "十月十六日事件-意味               ",
            "十月十六日事件-家乡      ",
            "十月十六日事件-1990年的春天               ",
            "十月十六日事件-冬妮娅               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/hei%20se%20xin%20feng.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/dong%20zhuo%20yao.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/chun%20mo%20nan%20fang%20cheng%20shi.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/lai%20le.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/guang%20chang.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/qing%20chun.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/ta%20men.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/bei%20jin%20ji%20de%20you%20xi.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/zhe%20ge%20shi%20jie%20hui%20hao%20ma.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/ma%20ma.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/ting%20mama.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/tuo%20luo.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/niao%20yu.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/huli.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/damo%20liulang.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/jiehun.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/laizi%20woxin.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/hukou%20tuoxian.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/lianlian%20fengchen.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/daoying.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/tuoniao.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/tiankong%20zhicheng.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/cangjingkong.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/yiwei.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/jiaxiang.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/1990de%20chuntian.mp3",
                "http://www.youxinpc.com.cn/music/Oct.%2016,%202009/dongniya.mp3",

            ]
		},
		{
		    "album": "我爱南京(2009)", "music": [
            "我爱南京-意味      ",
            "我爱南京-苍井空               ",
            "我爱南京-结婚      ",
            "我爱南京-鸵鸟               ",
			"我爱南京-天空之城      ",
            "我爱南京-倒影               ",
            "我爱南京-爱      ",
            "我爱南京-家乡               ",
			"我爱南京-1990年的春天               ",
            "我爱南京-冬妮娅      ",
            "我爱南京-听妈妈讲那过去的事情               ",
            "我爱南京-美丽的梭罗河      ",
            "我爱南京-米店               ",
            "我爱南京-思念观世音      ",
            "我爱南京-在那遥远的地方               ",
            "我爱南京-再见               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/love%20nanjing/01.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/02.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/03.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/04.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/05.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/06.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/07.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/08.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/09.mp3",
				"http://www.youxinpc.com.cn/music/love%20nanjing/10.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/11.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/12.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/13.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/14.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/15.mp3",
                "http://www.youxinpc.com.cn/music/love%20nanjing/16.mp3",
			
            ]
		},
		{
		    "album": "你好，郑州(2010)", "music": [
            "你好，郑州-墙上的向日葵      ",
            "你好，郑州-铅笔               ",
			"你好，郑州-关于郑州的记忆               ",
            "你好，郑州-忽然      ",
            "你好，郑州-秋天的老狼               ",
            "你好，郑州-带亲      ",
            "你好，郑州-她               ",
            "你好，郑州-路 (李志、邵夷贝)      ",
            "你好，郑州-夜               ",
            "你好，郑州-铅笔(吉松浩版)               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/zhengzhou/01.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/02.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/03.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/04.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/05.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/06.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/07.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/08.mp3",
                "http://www.youxinpc.com.cn/music/zhengzhou/09.mp3",
				"http://www.youxinpc.com.cn/music/zhengzhou/10.mp3",
			
            ]
		},
		{
		    "album": "F(2011)", "music": [
            "F-寻找      ",
            "F-尽头               ",
			"F-门               ",
            "F-下雨      ",
            "F-山阴路的夏天               ",
            "F-女神      ",
            "F-你的早晨               ",
            "F-杭州      ",
            "F-日               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/F/01.mp3",
                "http://www.youxinpc.com.cn/music/F/02.mp3",
                "http://www.youxinpc.com.cn/music/F/03.mp3",
                "http://www.youxinpc.com.cn/music/F/04.mp3",
                "http://www.youxinpc.com.cn/music/F/05.mp3",
                "http://www.youxinpc.com.cn/music/F/06.mp3",
                "http://www.youxinpc.com.cn/music/F/07.mp3",
                "http://www.youxinpc.com.cn/music/F/08.mp3",
                "http://www.youxinpc.com.cn/music/F/09.mp3",
			
            ]
		},
		{
		    "album": "Imagine(2011)", "music": [
            "Imagine-青春      ",
            "Imagine-离婚               ",
            "Imagine-我们不能失去信仰      ",
            "Imagine-喀纳斯               ",
            "Imagine-天空之城      ",
            "Imagine-苍井空               ",
            "Imagine-关于郑州的记忆      ",
            "Imagine-海的女儿               ",
			"Imagine-她               ",
            "Imagine-家乡      ",
            "Imagine-结婚               ",
            "Imagine-秋天的老狼      ",
            "Imagine-被禁忌的游戏               ",
            "Imagine-寻找      ",
            "Imagine-斜               ",
			"Imagine-和你在一起      ",
            "Imagine-门               ",
            "Imagine-尽头      ",
            "Imagine-女神               ",
			"Imagine-杭州               ",
            "Imagine-翁庆年的六英镑      ",
            "Imagine-红色气球               ",
            "Imagine-1990的春天      ",
            "Imagine-结尾               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/Imagine/01.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/02.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/03.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/04.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/05.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/06.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/07.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/08.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/09.mp3",
				"http://www.youxinpc.com.cn/music/Imagine/10.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/11.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/12.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/13.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/14.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/15.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/16.mp3",
				"http://www.youxinpc.com.cn/music/Imagine/17.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/18.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/19.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/20.mp3",
				"http://www.youxinpc.com.cn/music/Imagine/21.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/22.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/23.mp3",
                "http://www.youxinpc.com.cn/music/Imagine/24.mp3",

            ]
		},
		{
		    "album": "108个关键词(2012)", "music": [
            "108个关键词-下雨      ",
            "108个关键词-人民不需要自由               ",
            "108个关键词-倒影      ",
            "108个关键词-关于郑州的记忆               ",
            "108个关键词-和你在一起      ",
            "108个关键词-和你在一起合唱               ",
            "108个关键词-墙上的向日葵      ",
            "108个关键词-她+我们不能失去信仰+1990年的春天               ",
			"108个关键词-姐姐               ",
            "108个关键词-尽头      ",
            "108个关键词-山阴路独白版               ",
            "108个关键词-山阴路的夏天      ",
            "108个关键词-广场               ",
            "108个关键词-忽然      ",
            "108个关键词-来了               ",
			"108个关键词-董卓瑶      ",
            "108个关键词-阿兰               ",
            "108个关键词-青春      ",
            "108个关键词-黑色信封               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/108/01.mp3",
                "http://www.youxinpc.com.cn/music/108/02.mp3",
                "http://www.youxinpc.com.cn/music/108/03.mp3",
                "http://www.youxinpc.com.cn/music/108/04.mp3",
                "http://www.youxinpc.com.cn/music/108/05.mp3",
                "http://www.youxinpc.com.cn/music/108/06.mp3",
                "http://www.youxinpc.com.cn/music/108/07.mp3",
                "http://www.youxinpc.com.cn/music/108/08.mp3",
                "http://www.youxinpc.com.cn/music/108/09.mp3",
				"http://www.youxinpc.com.cn/music/108/10.mp3",
                "http://www.youxinpc.com.cn/music/108/11.mp3",
                "http://www.youxinpc.com.cn/music/108/12.mp3",
                "http://www.youxinpc.com.cn/music/108/13.mp3",
                "http://www.youxinpc.com.cn/music/108/14.mp3",
                "http://www.youxinpc.com.cn/music/108/15.mp3",
                "http://www.youxinpc.com.cn/music/108/16.mp3",
				"http://www.youxinpc.com.cn/music/108/17.mp3",
                "http://www.youxinpc.com.cn/music/108/18.mp3",
                "http://www.youxinpc.com.cn/music/108/19.mp3",

            ]
		},
		{
		    "album": "勾三搭四(2013)", "music": [
            "勾三搭四-1990年的春天      ",
            "勾三搭四-下雨               ",
            "勾三搭四-和你在一起               ",
            "勾三搭四-墙上的向日葵      ",
            "勾三搭四-妈妈               ",
            "勾三搭四-山阴路的夏天      ",
            "勾三搭四-意味               ",
			"勾三搭四-斜               ",
            "勾三搭四-春末的南方城市      ",
            "勾三搭四-来了               ",
            "勾三搭四-杭州&我们不能失去信仰      ",
            "勾三搭四-离婚               ",
            "勾三搭四-秋天的老狼      ",
            "勾三搭四-翁庆年的六英镑               ",
			"勾三搭四-董卓瑶      ",
            "勾三搭四-被禁忌的游戏               ",
            "勾三搭四-这个世界会好吗      ",
			"勾三搭四-铅笔               ",
            "勾三搭四-门      ",
            "勾三搭四-黑色信封               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/34/01.mp3",
                "http://www.youxinpc.com.cn/music/34/02.mp3",
                "http://www.youxinpc.com.cn/music/34/03.mp3",
                "http://www.youxinpc.com.cn/music/34/04.mp3",
                "http://www.youxinpc.com.cn/music/34/05.mp3",
                "http://www.youxinpc.com.cn/music/34/06.mp3",
                "http://www.youxinpc.com.cn/music/34/07.mp3",
                "http://www.youxinpc.com.cn/music/34/08.mp3",
                "http://www.youxinpc.com.cn/music/34/09.mp3",
				"http://www.youxinpc.com.cn/music/34/10.mp3",
                "http://www.youxinpc.com.cn/music/34/11.mp3",
                "http://www.youxinpc.com.cn/music/34/12.mp3",
                "http://www.youxinpc.com.cn/music/34/13.mp3",
                "http://www.youxinpc.com.cn/music/34/14.mp3",
                "http://www.youxinpc.com.cn/music/34/15.mp3",
                "http://www.youxinpc.com.cn/music/34/16.mp3",
				"http://www.youxinpc.com.cn/music/34/17.mp3",
                "http://www.youxinpc.com.cn/music/34/18.mp3",
                "http://www.youxinpc.com.cn/music/34/19.mp3",
				"http://www.youxinpc.com.cn/music/34/20.mp3",

            ]
		},
		{
		    "album": "1701(2014)", "music": [
            "1701-大象      ",
            "1701-鼠说               ",
			"1701-定西               ",
            "1701-看见      ",
            "1701-不多               ",
            "1701-热河      ",
            "1701-好威武支持有希望               ",
            "1701-方式               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/1701/01.mp3",
                "http://www.youxinpc.com.cn/music/1701/02.mp3",
                "http://www.youxinpc.com.cn/music/1701/03.mp3",
                "http://www.youxinpc.com.cn/music/1701/04.mp3",
                "http://www.youxinpc.com.cn/music/1701/05.mp3",
                "http://www.youxinpc.com.cn/music/1701/06.mp3",
                "http://www.youxinpc.com.cn/music/1701/07.mp3",
                "http://www.youxinpc.com.cn/music/1701/08.mp3",
			
            ]
		},
		{
		    "album": "iO(2014)", "music": [
            "iO-杭州      ",
            "iO-墙上的向日葵               ",
			"iO-铅笔               ",
            "iO-来了      ",
            "iO-下雨&董卓瑶&忽然               ",
            "iO-这个世界会好吗      ",
            "iO-妈妈               ",
            "iO-定西      ",
			"iO-方式               ",
            "iO-鸵鸟&天空之城&我们不能失去信仰      ",
            "iO-山阴路的夏天               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/io/01.mp3",
                "http://www.youxinpc.com.cn/music/io/02.mp3",
                "http://www.youxinpc.com.cn/music/io/03.mp3",
                "http://www.youxinpc.com.cn/music/io/04.mp3",
                "http://www.youxinpc.com.cn/music/io/05.mp3",
                "http://www.youxinpc.com.cn/music/io/06.mp3",
                "http://www.youxinpc.com.cn/music/io/07.mp3",
                "http://www.youxinpc.com.cn/music/io/08.mp3",
                "http://www.youxinpc.com.cn/music/io/09.mp3",
				"http://www.youxinpc.com.cn/music/io/10.mp3",
                "http://www.youxinpc.com.cn/music/io/11.mp3",
			
            ]
		},
		{
		    "album": "看见(2015)", "music": [
            "看见-看见      ",
            "看见-黑色信封               ",
			"看见-苍井空               ",
            "看见-春末的南方城市      ",
            "看见-你离开了南京，从此没有人和我说话               ",
            "看见-下雨      ",
            "看见-热河               ",
            "看见-董卓瑶      ",
			"看见-离婚               ",
            "看见-梵高先生               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/kanjian/01.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/02.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/03.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/04.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/05.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/06.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/07.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/08.mp3",
                "http://www.youxinpc.com.cn/music/kanjian/09.mp3",
				"http://www.youxinpc.com.cn/music/kanjian/10.mp3",
			
            ]
		},
		{
		    "album": "动静(2015)", "music": [
            "动静-好威武支持有希望+倒影+青春+人民不需要自由(2015动静版)      ",
            "动静-你的早晨               ",
			"动静-普希金               ",
            "动静-卡夫卡      ",
            "动静-和你在一起               ",
            "动静-忽然      ",
            "动静-定西               ",
            "动静-地方      ",
			"动静-这个世界会好吗               ",
			"动静-墙上的向日葵               ",
            "动静-尽头               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/dongjing/01.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/02.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/03.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/04.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/05.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/06.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/07.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/08.mp3",
                "http://www.youxinpc.com.cn/music/dongjing/09.mp3",
				"http://www.youxinpc.com.cn/music/dongjing/10.mp3",
				"http://www.youxinpc.com.cn/music/dongjing/11.mp3",
			
            ]
		},
		{
		    "album": "北京不插电现场(2016)", "music": [
            "北京不插电现场-黑色信封      ",
            "北京不插电现场-鸵鸟               ",
			"北京不插电现场-大象               ",
            "北京不插电现场-定西      ",
            "北京不插电现场-这个世界会好吗               ",
            "北京不插电现场-结婚      ",
            "北京不插电现场-关于郑州的记忆               ",
            "北京不插电现场-杭州      ",
			"北京不插电现场-热河               ",
			"北京不插电现场-春末的南方城市               ",
			"北京不插电现场-鼠说               ",
            "北京不插电现场-山阴路的夏天               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/beijing/01.mp3",
                "http://www.youxinpc.com.cn/music/beijing/02.mp3",
                "http://www.youxinpc.com.cn/music/beijing/03.mp3",
                "http://www.youxinpc.com.cn/music/beijing/04.mp3",
                "http://www.youxinpc.com.cn/music/beijing/05.mp3",
                "http://www.youxinpc.com.cn/music/beijing/06.mp3",
                "http://www.youxinpc.com.cn/music/beijing/07.mp3",
                "http://www.youxinpc.com.cn/music/beijing/08.mp3",
                "http://www.youxinpc.com.cn/music/beijing/09.mp3",
				"http://www.youxinpc.com.cn/music/beijing/10.mp3",
				"http://www.youxinpc.com.cn/music/beijing/11.mp3",
				"http://www.youxinpc.com.cn/music/beijing/12.mp3",
			
            ]
		},
		{
		    "album": "8(2016)", "music": [
            "8-歌声与微笑               ",
            "8-蜗牛与黄鹂鸟      ",
            "8-兰花草               ",
            "8-数鸭子      ",
			"8-朋友越多越快乐               ",
			"8-Hey Jude               ",
			"8-采蘑菇的小姑娘               ",
            "8-小螺号               ",
			"8-送别               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/8/01.mp3",
                "http://www.youxinpc.com.cn/music/8/02.mp3",
                "http://www.youxinpc.com.cn/music/8/03.mp3",
                "http://www.youxinpc.com.cn/music/8/04.mp3",
                "http://www.youxinpc.com.cn/music/8/05.mp3",
                "http://www.youxinpc.com.cn/music/8/06.mp3",
                "http://www.youxinpc.com.cn/music/8/07.mp3",
                "http://www.youxinpc.com.cn/music/8/08.mp3",
				"http://www.youxinpc.com.cn/music/8/09.mp3",
			
            ]
		},
		{
		    "album": "在每一条伤心的应天大街上(2016)", "music": [
            "在每一条伤心的应天大街上               ",
            "在每一条伤心的应天大街上-一头偶像      ",
            "在每一条伤心的应天大街上-克兰河               ",
            "在每一条伤心的应天大街上-死人      ",
			"在每一条伤心的应天大街上-一个夜晚               ",
			"在每一条伤心的应天大街上-哦吼               ",
			"在每一条伤心的应天大街上-彩色派对               ",
			"在每一条伤心的应天大街上-你好明天               ",
            "在每一条伤心的应天大街上-地方               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/dajie/01.mp3",
                "http://www.youxinpc.com.cn/music/dajie/02.mp3",
                "http://www.youxinpc.com.cn/music/dajie/03.mp3",
                "http://www.youxinpc.com.cn/music/dajie/04.mp3",
                "http://www.youxinpc.com.cn/music/dajie/05.mp3",
                "http://www.youxinpc.com.cn/music/dajie/06.mp3",
                "http://www.youxinpc.com.cn/music/dajie/07.mp3",
                "http://www.youxinpc.com.cn/music/dajie/08.mp3",
				"http://www.youxinpc.com.cn/music/dajie/09.mp3",
			
            ]
		},
		{
		    "album": "电声与管弦乐(2016)", "music": [
            "电声与管弦乐-序曲      ",
            "电声与管弦乐-杭州               ",
			"电声与管弦乐-尽头               ",
            "电声与管弦乐-定西      ",
            "电声与管弦乐-春末的南方城市               ",
            "电声与管弦乐-黑色信封      ",
            "电声与管弦乐-铅笔               ",
            "电声与管弦乐-和你在一起      ",
			"电声与管弦乐-墙上的向日葵               ",
			"电声与管弦乐-大象               ",
			"电声与管弦乐-门               ",
            "电声与管弦乐-回答               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/dian/01.mp3",
                "http://www.youxinpc.com.cn/music/dian/02.mp3",
                "http://www.youxinpc.com.cn/music/dian/03.mp3",
                "http://www.youxinpc.com.cn/music/dian/04.mp3",
                "http://www.youxinpc.com.cn/music/dian/05.mp3",
                "http://www.youxinpc.com.cn/music/dian/06.mp3",
                "http://www.youxinpc.com.cn/music/dian/07.mp3",
                "http://www.youxinpc.com.cn/music/dian/08.mp3",
                "http://www.youxinpc.com.cn/music/dian/09.mp3",
				"http://www.youxinpc.com.cn/music/dian/10.mp3",
				"http://www.youxinpc.com.cn/music/dian/11.mp3",
				"http://www.youxinpc.com.cn/music/dian/12.mp3",
			
            ]
		},
		{
		    "album": "爵士乐与不插电新编12首(2017)", "music": [
            "爵士乐与不插-一个夜晚      ",
            "爵士乐与不插-关于郑州的记忆               ",
			"爵士乐与不插-卡夫卡               ",
            "爵士乐与不插-死人      ",
            "爵士乐与不插-热河               ",
            "爵士乐与不插-爱      ",
            "爵士乐与不插-看见               ",
            "爵士乐与不插-离婚      ",
			"爵士乐与不插-翁庆年的六英镑               ",
			"爵士乐与不插-董卓瑶               ",
			"爵士乐与不插-鸵鸟               ",
            "爵士乐与不插-鼠说               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/jueshi/01.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/02.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/03.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/04.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/05.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/06.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/07.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/08.mp3",
                "http://www.youxinpc.com.cn/music/jueshi/09.mp3",
				"http://www.youxinpc.com.cn/music/jueshi/10.mp3",
				"http://www.youxinpc.com.cn/music/jueshi/11.mp3",
				"http://www.youxinpc.com.cn/music/jueshi/12.mp3",
			
            ]
		},
		{
		    "album": "电声与管弦乐Ⅱ(2018)", "music": [
            "电声与管弦乐Ⅱ-家乡      ",
            "电声与管弦乐Ⅱ-你好明天               ",
            "电声与管弦乐Ⅱ-哦吼      ",
            "电声与管弦乐Ⅱ-山阴路的夏天               ",
            "电声与管弦乐Ⅱ-天空之城      ",
			"电声与管弦乐Ⅱ-序曲               ",
			"电声与管弦乐Ⅱ-寻找               ",
			"电声与管弦乐Ⅱ-一头偶像               ",
            "电声与管弦乐Ⅱ-这个世界会好吗               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/xiangxin/01.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/02.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/03.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/04.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/05.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/06.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/07.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/08.mp3",
                "http://www.youxinpc.com.cn/music/xiangxin/09.mp3",
			
            ]
		},
		{
		    "album": "洗心革面(2019)", "music": [
            "洗心革面-被禁忌的游戏               ",
			"洗心革面-春末的南方的城市               ",
            "洗心革面-倒影      ",
            "洗心革面-董卓瑶               ",
            "洗心革面-关于郑州的记忆      ",
            "洗心革面-和你在一起               ",
            "洗心革面-黑色信封      ",
            "洗心革面-吉他曲               ",
			"洗心革面-洗心革面-结婚      ",
            "洗心革面-来了               ",
            "洗心革面-路      ",
            "洗心革面-门               ",
			"洗心革面-你好明天               ",
            "洗心革面-你离开了南京从此没人和我说话      ",
            "洗心革面-哦吼               ",
            "洗心革面-天空之城      ",
            "洗心革面-寻找               ",
            "洗心革面-一个夜晚      ",
            "洗心革面-定西               ",
            "洗心革面-不多               "
            ],"urls":[
                "http://www.youxinpc.com.cn/music/xi/1.mp3",
                "http://www.youxinpc.com.cn/music/xi/2.mp3",
                "http://www.youxinpc.com.cn/music/xi/3.mp3",
                "http://www.youxinpc.com.cn/music/xi/4.mp3",
                "http://www.youxinpc.com.cn/music/xi/5.mp3",
                "http://www.youxinpc.com.cn/music/xi/6.mp3",
                "http://www.youxinpc.com.cn/music/xi/7.mp3",
                "http://www.youxinpc.com.cn/music/xi/8.mp3",
				"http://www.youxinpc.com.cn/music/xi/9.mp3",
				"http://www.youxinpc.com.cn/music/xi/10.mp3",
                "http://www.youxinpc.com.cn/music/xi/11.mp3",
                "http://www.youxinpc.com.cn/music/xi/12.mp3",
                "http://www.youxinpc.com.cn/music/xi/13.mp3",
                "http://www.youxinpc.com.cn/music/xi/14.mp3",
                "http://www.youxinpc.com.cn/music/xi/15.mp3",
                "http://www.youxinpc.com.cn/music/xi/16.mp3",
                "http://www.youxinpc.com.cn/music/xi/17.mp3",
                "http://www.youxinpc.com.cn/music/xi/18.mp3",
				"http://www.youxinpc.com.cn/music/xi/19.mp3",
				"http://www.youxinpc.com.cn/music/xi/20.mp3",
            ]
		},		{		    "album": "未发售数字版&Live音频", "music": [            
		"未发售数字版-梵高先生      ",            
		"未发售数字版-公路之光               ",            
		"未发售数字版-广场      ",            
		"未发售数字版-鹿港小镇               ",            
		"未发售数字版-山阴路的夏天      ",			
		"未发售数字版-新年好呀               ",			
		"未发售数字版-长安县               ",            
		"未发售数字版-走进新时代               "            
		],"urls":[                
		"http://www.youxinpc.com.cn/music/wei/1.mp3",                
		"http://www.youxinpc.com.cn/music/wei/2.mp3",                
		"http://www.youxinpc.com.cn/music/wei/3.mp3",                
		"http://www.youxinpc.com.cn/music/wei/4.mp3",                
		"http://www.youxinpc.com.cn/music/wei/5.mp3",                
		"http://www.youxinpc.com.cn/music/wei/6.mp3",                
		"http://www.youxinpc.com.cn/music/wei/7.mp3",                
		"http://www.youxinpc.com.cn/music/wei/8.mp3",			            
		]		},		
        {
		    "album": "我的最爱，感谢大家一路支持", "music": [
			"李志-和你在一起               "
            ],"urls":[
                 "http://www.youxinpc.com.cn/music/dian/08.mp3",

            ]
        }
        ];
    function trim(s) {
        return s.replace(/(^\s*)|(\s*$)/g, "");
    }
	//var path = "http://www.youxinpc.com.cn/music";
	var musicpath = [];       //存储所有播放路径和曲目名称
    var allmusicpath = [];
     // console.log(allmuisc);

	for(var i in allmuisc){
		for(j in allmuisc[i].music){
			//musicpath.push([path + "/" + allmuisc[i].album + "/" + trim(allmuisc[i].music[j]),trim(allmuisc[i].music[j])]);
			//allmusicpath.push([path + "/" + allmuisc[i].album + "/" + trim(allmuisc[i].music[j]),trim(allmuisc[i].music[j])]);
            musicpath.push([allmuisc[i].urls[j],trim(allmuisc[i].music[j])]);
            allmusicpath.push([allmuisc[i].urls[j],trim(allmuisc[i].music[j])]);
		}
	}



	function randomsort(a, b) {
		return Math.random() > .5 ? -1 : 1;
	};
	var playlist = [];   //存储播放id
	for (var i = 0; i < musicpath.length; i++) {
		playlist.push(i);
	}
	playlist.sort(randomsort);

	var myAudio = $("#player")[0];


    current_music_id = 0; //当前播放id


	current_music_path= musicpath[playlist[current_music_id]][0];//当前播放路径
	$("#title").text(musicpath[playlist[current_music_id]][1].replace(".mp3","").replace(".flac","").replace(".m4a", "").replace(".wav", ""));

	myAudio.src = current_music_path;
	// var pagetitle = musicpath[playlist[current_music_id]][1].replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", "")+" || 我爱南京专属LiveHouse"
    // $(document).attr("title",pagetitle);//修改title值


	function play() {
		myAudio.play();
		$("#onoff").html('<i class="fa fa-pause fa-3x"></i>');

		delta = 0.2;
		// $(document).attr("title",musicpath[playlist[current_music_id]][1].replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", "")+" || 我爱南京专属LiveHouse");//修改title值
	}

	function pause() {
		myAudio.pause();
		$("#onoff").html('<i class="fa fa-play fa-3x"></i>');
		delta = 0;

	}

	function turnonoff() {
		if (myAudio.paused) { /*如果已经暂停*/
			play();   //播放

		} else {
			pause();  //暂停
		}
	}

	function repeatonoff() {
        if(whetherrepeat){
            // 如果单曲循环
            $("#mode").attr("src", "images/Shuffle.png");
            whetherrepeat = false;
        }else {
            // 如果随机播放
            $("#mode").attr("src", "images/Repeat.png");
            whetherrepeat = true;

        }
    }

    function lastone() {
        if (current_music_id == 0) {
            current_music_id = musicpath.length-1;
        } else {
            current_music_id -= 1;
            $("#img").attr("src", 'images/' + Math.floor(Math.random() * 19) + '.jpg');

		}
		current_music_path = musicpath[playlist[current_music_id]][0];
		$("#title").text(musicpath[playlist[current_music_id]][1].replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", ""));
		myAudio.src = current_music_path;
		play();
	}

    function nextone() {
        if (current_music_id == musicpath.length - 1) {
            current_music_id = 0;
        } else {
            current_music_id += 1;
            $("#img").attr("src", 'images/' + Math.floor(Math.random() * 19) + '.jpg');
        }
        current_music_path = musicpath[playlist[current_music_id]][0];
        $("#title").text(musicpath[playlist[current_music_id]][1].replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", ""));
        myAudio.src = current_music_path;
        play();
    }


    //进度条控制
    setInterval(present, 100);	//每0.1秒计算进度条长度
    $(".basebar").mousedown(function (ev) {  //拖拽进度条控制进度
        var posX = ev.offsetX;
        var targetLeft = $(this).offset().left;
        var basebarwidth = $(".basebar").width();
        var percentage = (posX) / basebarwidth * 100;
        myAudio.currentTime = myAudio.duration * percentage / 100;
    });

    function present() {
        var length = myAudio.currentTime / myAudio.duration * 100;
        $('.progressbar').width(length + '%');//设置进度条长度
        //自动下一曲
        // if (myAudio.currentTime == myAudio.duration) {
        // 	nextone();
        // }

        if(myAudio.ended || myAudio.currentTime == myAudio.duration){
            if (whetherrepeat) {
                // 如果重复播放，则直接播放
                myAudio.play();
                return;
            } else {
                // 如果随机，继续下一曲
                nextone();
            }
        }
        $("#currenttime").html(s_to_hs(parseInt(myAudio.currentTime)));
        $("#totaltime").html(s_to_hs(parseInt(myAudio.duration)));

    };
    var angle = 0;
    var delta = 0;
    setInterval(function () {
        angle += delta;
        $('#cover').rotate(angle);
    }, 40);

	function s_to_hs(s) {
		//计算分钟
		//算法：将秒数除以60，然后下舍入，既得到分钟数
		var h;
		h = Math.floor(s / 60);
		//计算秒
		//算法：取得秒%60的余数，既得到秒数
		s = s % 60;
		//将变量转换为字符串
		h += '';
		s += '';
		//如果只有一位数，前面增加一个0
		h = (h.length == 1) ? '0' + h : h;
		s = (s.length == 1) ? '0' + s : s;
		if(isNaN(h)){
		    return "&infin;"
        }
		return h + ':' + s;
	};
	String.prototype.replaceAll = function (exp, newStr) {
		return this.replace(new RegExp(exp, "gm"), newStr);
	};
	String.prototype.format = function (args) {
		var result = this;
		if (arguments.length < 1) {
			return result;
		}

		var data = arguments; // 如果模板参数是数组
		if (arguments.length == 1 && typeof (args) == "object") {
			// 如果模板参数是对象
			data = args;
		}
		for (var key in data) {
			var value = data[key];
			if (undefined != value) {
				result = result.replaceAll("\\{" + key + "\\}", value);
			}
		}
		return result;
	};

	function StringFormat() {
		if (arguments.length == 0)
			return null;
		var str = arguments[0];
		for (var i = 1; i < arguments.length; i++) {
			var re = new RegExp('\\{' + (i - 1) + '\\}', 'gm');
			str = str.replace(re, arguments[i]);
		}
		return str;
	};
	$(function () {
		$("#accordion").empty();
		var playlisttemp = '';
		var htmlrender = '<li>' +
				'<div class="link">' +
				'<i>{0}</i>' +
				'<div class="album">{1}</div>' +
				'<i class="fa fa-chevron-down"></i>' +
				'</div>' +
				'<ul class="submenu">' +
				' {2}' +
				'</ul>' +
				'</li>';
		for (var i in allmuisc) {
			var id = i;
			var albumname = allmuisc[i].album;
			var lis = "<li><a class='playall' albumname='"+albumname+"' urls='"+allmuisc[i].urls[j]+"' style='text-align: left;  background: #4D4D4D;'>>> 播放全部</a></li>";
			for (j in allmuisc[i].music) {
                //href = path + "/" + allmuisc[i].album + "/" + trim(allmuisc[i].music[j]);
				href = allmuisc[i].urls[j];
				musicname = trim(allmuisc[i].music[j]);
				lis = lis + '<li><a class="url" hrefsrc="' + href + '">' + musicname + '</a></li>';
			}

			playlisttemp += htmlrender.format(parseInt(id) + 1, albumname, lis);

		}
		$("#accordion").append(playlisttemp);


		var Accordion = function (el, multiple) {
			this.el = el || {};
			this.multiple = multiple || false;

			// Variables privadas
			var links = this.el.find('.link');
			// Evento
			links.on('click', {el: this.el, multiple: this.multiple}, this.dropdown)
		}

		Accordion.prototype.dropdown = function (e) {
			var $el = e.data.el;
			$this = $(this),
					$next = $this.next();

			$next.slideToggle();
			$this.parent().toggleClass('open');

			if (!e.data.multiple) {
				$el.find('.submenu').not($next).slideUp().parent().removeClass('open');
			}
			;
		}

        var accordion = new Accordion($('#accordion'), false);

        $("a.url").bind("click", function () {
            myAudio.src = this.getAttribute("hrefsrc");
            $("#title").text(this.innerHTML.replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", ""));
            $("#img").attr("src", 'images/' + Math.floor(Math.random() * 19) + '.jpg');

            play();


        });

        $("a.playall").bind("click", function () {

            var albumname = this.getAttribute("albumname");
            var urls = this.getAttribute("urls");
           // console.log(albumname);
            //console.log(allmusicpath);

            for(var s in allmuisc){
                //for(j in allmuisc[i].music){
                    if(allmuisc[s].album==albumname){
                        //musicpath_new.push([allmuisc[i]['urls'],(allmuisc[i]['music'])]);
                       var musicpath_news=[allmuisc[s]['urls'],(allmuisc[s]['music'])];
                       break;
                    }
            //}
        }
            //console.log(musicpath_news);
            //return ;
            //alert(urls);
            
      
            musicpath_new = [];
            for(var i=0;i<musicpath_news[0].length;i++){
                    musicpath_new.push([musicpath_news[0][i],trim(musicpath_news[1][i])]);
            }
            
            //console.log(musicpath_new);
            //return;
            //替换新的musicpath
            musicpath = musicpath_new;

            playlist = [];   //清空playlist
            //重新添加播放顺序
            for (var i = 0; i < musicpath.length; i++) {
                playlist.push(i);
            }
            // playlist.sort(randomsort); //顺序播放不随机
            //重置current id和path
            current_music_id = 0;
            current_music_path = musicpath[playlist[current_music_id]][0];//当前播放路径
            //console.log(current_music_path);
            //return;
            $("#title").text(musicpath[playlist[current_music_id]][1].replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", ""));

            myAudio.src = current_music_path;

            //console.log(current_music_id);
            //console.log(current_music_path);
            play();



            // myAudio.src = this.getAttribute("albumname");
            // $("#title").text(this.innerHTML.replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", ""));
            // $("#img").attr("src", 'images/' + Math.floor(Math.random() * 11) + '.jpg');
            //
            // play();


        });
        $("#randomall").bind("click", function () {

        musicpath_new = [];
        for (var i = 0; i < allmusicpath.length; i++) {
            musicpath_new.push(allmusicpath[i]);

        }
        //console.log(musicpath_new);
        //替换新的musicpath
        musicpath = musicpath_new;

        playlist = [];   //清空playlist
        //重新添加播放顺序
        for (var i = 0; i < musicpath.length; i++) {
            playlist.push(i);
        }
        playlist.sort(randomsort);
        //重置current id和path
        current_music_id = 0;
        current_music_path = musicpath[playlist[current_music_id]][0];//当前播放路径
        $("#title").text(musicpath[playlist[current_music_id]][1].replace(".mp3", "").replace(".flac", "").replace(".m4a", "").replace(".wav", ""));

        myAudio.src = current_music_path;

        //console.log(current_music_id);
        //console.log(current_music_path);
        play();


    });

    });