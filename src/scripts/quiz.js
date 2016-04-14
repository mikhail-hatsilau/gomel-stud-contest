$ = require('jquery');

$(function (){

	// var taskNumber = parseInt(localStorage.getItem('quizTaskNumber'));
	var taskId = parseInt(localStorage.getItem('quizTaskId'));
	var rootNode;
	var startTime;
	var intervalId;
	var timer;
	var forbidden;
	var forbiddenFlag = true;
	var savedTime;
	var timeLimit = parseInt(localStorage.getItem('timeLimit'));

	String.prototype.replaceAll = function (exp, str) {
		return this.split(exp).join(str);
	}

	function formatHtml(str) {
		var result = str;
		var spanRed = "%1"; // <span class='red'>
		var spanGreen = "%2"; // <span class='green'>
		var spanYellow = "%3"; // <span class='yellow'>
		var closeSpan = "%4"; // </span>
		var tags = str.split(/&lt;/g);
		var attrs = str.split("=");
		var values = str.split("\"");

		//tagNames
		if (tags.length > 0) {
			(function (){
				for (var i = 1; i < tags.length; i++) {
					var insertStr = "";
					if (tags[i][0] === "/") {
						insertStr += "/" + spanRed + tags[i].substring(1).split("&gt;")[0] + closeSpan;
						result = result.replaceAll("&lt;" + tags[i].split("&gt;")[0], "&lt;" + insertStr);
					} else {
						if (tags[i].split(" ").length > 1) {
							insertStr += spanRed + tags[i].split(" ")[0] + closeSpan;
							result = result.replaceAll("&lt;" + tags[i].split(" ")[0], "&lt;" + insertStr);
						} else {
							insertStr += spanRed + tags[i].split("&gt;")[0] + closeSpan;
							result = result.replaceAll("&lt;" + tags[i].split("&gt;")[0], "&lt;" + insertStr);
						}
					}
				}
			}());
		}

		//attrs
		if (attrs.length > 0) {
			(function (){
				for (var i = 0; i < attrs.length - 1; i++) {
					var attr = attrs[i].split(" ")[attrs[i].split(" ").length - 1];
					var insertStr = spanGreen + attr + closeSpan + "=";
					result = result.replaceAll(attr + "=", insertStr);
				}
			}());
		}

		//attr values
		if (values.length > 0) {
			(function (){
				for (var i = 1; i < values.length - 1; i++) {
					if (i % 2 != 0) {
						var insertStr = spanYellow + values[i] + closeSpan;
						result = result.replaceAll(values[i], insertStr);
					}
				}
			}());
		}

		result = result.replace(/\"/g, "<span class='yellow'>\"</span>").replaceAll(spanRed, "<span class='red'>").replaceAll(spanGreen, "<span class='green'>")
			.replaceAll(spanYellow, "<span class='yellow'>").replaceAll(closeSpan, "</span>");
		return result;
	}

	var hideHtmlBlock = function (){
		$('.html-wrapper').css('left', '-2000px').css('top', '-300px').css('transform', 'rotate(-90deg) scale(2)');
	};

	var showHtmlBlock = function (){
		$('.html-wrapper').css('left', '0').css('top', '0').css('transform', 'rotate(0) scale(1)');
	};

	function simpleTimer(block, timeLimit) {
	    // var time = (+$(block).html().split(':')[0]) * 60 + (+$(block).html().split(':')[1]);
	    var minutes = parseInt(timer / 60);

	    if ( minutes < 1 ) minutes = 0;
	    if ( minutes < 10 ) minutes = '0' + minutes;

	    var seconds = parseInt(timer - minutes * 60);
	    if ( seconds < 10 ) seconds = '0' + seconds;

	    $(block).html(minutes + ':' + seconds);

	    if (timeLimit) {
	    	if (timeLimit - timer <= 10) {
		    	$(block).addClass('red-color');
		    	setTimeout(function(){
		    		$(block).removeClass('red-color');
		    	}, 400);
		    }
	    }
	}

	var showTask = function (){

		// function finish() {
		// 	localStorage.removeItem('quizTaskNumber');
		// 	$.ajax({
		// 		url: '/finishQuiz',
		// 		method: 'POST'
		// 	})
		// 	.done(function(){
		// 		location.href = '/finishResults'
		// 	})
		// 	.fail(function(){
		// 		console.log('Error occured')
		// 	});
		// }

		$.get("/quizTasks/" + taskId, function (data) {
			// showHtmlBlock();
			var START_TAG_REGEXP = /\<[a-zA-Z]+/g;
			var matchResult;

			startTime = new Date();
			savedTime = localStorage.getItem('quizTime') || undefined
			if(savedTime) {
				startTime.setSeconds(startTime.getSeconds() - savedTime);
			}
			$('.timer').html('00:00');
			timer = savedTime || 0;
			intervalId = setInterval(function (){
				timer++;
				localStorage.setItem('quizTime', timer);
				simpleTimer($('.timer'), timeLimit);
				if (timeLimit && timer >= timeLimit) {
					emitEvent(taskId, timeLimit, '', false);
					completeTask();
				}
			}, 1000);
			forbiddenFlag = true;
			$('.html-code').html("");
			var lines = data.htmlCode.split("\n");
			var needed = data.answares.split(",").map(Number);
			if (data.deprecatedSelectors.trim().length === 0) {
				forbidden = []
			} else {
				forbidden = data.deprecatedSelectors.split(' ');
			}
			$('.forbidden .data').html(forbidden.join('&nbsp&nbsp&nbsp'));

			var linesWithRowNumber = []
			for (var i = 0; i < lines.length; i++) {
				var line = lines[i]
				if (START_TAG_REGEXP.test(line)){
					matchResult = line.match(START_TAG_REGEXP);
					matchResult.forEach(function(element){
						var index = line.indexOf(element);
						var firstSubString = line.slice(0, index + element.length)
						var secondSubString = line.slice(firstSubString.length, line.length)
						line = firstSubString + ' data-csstest-row="' + i + '" ' + secondSubString
					});
				}
				linesWithRowNumber.push(line);
			}
			rootNode = $("<div/>");
			rootNode.append(linesWithRowNumber.join('\n'));
			// $(rootNode).find('*').each(function (index){
			// 	console.log(index);
			// 	$(this).attr('data-csstest-row', index);
			// });
			for (var i = 0; i < lines.length; i++) {
				var source = $("<div/>").text(lines[i]).html();
				var html = "<tr><td class='line-num'>" + (i+1) + "</td><td><div class='flag'></div></td><td class='code'>" + formatHtml(source.replace(/\t/g, "&nbsp;&nbsp;&nbsp;&nbsp;")) + "</td></tr>";
				var codeElement = $(html)
				if (needed.indexOf(i) >= 0) {
					// html = $("<div/>").append($(html).addClass('needed')).html();
					codeElement.addClass('needed')
				}
				$('.html-code').append(codeElement);
			}
		}).fail(function (){
			//finish();
			//$('.html-wrapper').html("<span style='color: #fff;'>That's all! You are <span style='color: red;'>C</span><span style='color: green;'>S</span><span style='color: blue;'>S</span>-master :)</span>");
			//location.replace('/readyQuiz');
			console.log('Error');
		});
	};

	socketIo.on('stop', function(){
		emitEvent(taskId, timeLimit, '', false);
		completeTask()
	});

	function completeTask() {
		// hideHtmlBlock();
		// clearInterval(intervalId);
		// localStorage.removeItem('quizTaskTime', timer);
		// setTimeout(function () {
		// 	showTask(++taskNumber);
		// }, 400);
		// $('.selector').val("");
		// hideHtmlBlock();
		// $('.selector').val("");
		clearInterval(intervalId);
		setTimeout(function(){
			location.replace('/readyQuiz');
		}, 500);
	}

	var checkForWelldone = function (selector){
		var needed = $('.needed');
		var time;
		if (needed.length > 0) {
			for (var i = 0; i < needed.length; i++) {
				if (!$(needed[i]).hasClass('selected')) {
					return false;
				}
			}
			if (needed.length == $('.selected').length && forbiddenFlag) {
				time = (new Date() - startTime)/1000;
				clearInterval(intervalId);
				emitEvent(taskId, time, selector, true);
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	};

	function emitEvent(taskId, time, selector, passed) {
		socketIo.emit('pass test', {
			taskId: taskId,
			time: time,
			timeLimit: timeLimit,
			selector: selector,
			passed: passed
		});
	}

	var runSelector = function (selector) {
		$('.html-code tr').removeClass('selected');
		try {
			for (var i = 0; i < forbidden.length; i++) {
				if (selector.indexOf(forbidden[i]) != -1) {
					$('.input-wrapper').addClass('error');
					$('.forbidden-error').show()
					forbiddenFlag = false;
					break;
				} else {
					$('.input-wrapper').removeClass('error');
					$('.forbidden-error').hide()
					forbiddenFlag = true;
				}
			}
			var result = rootNode[0].querySelectorAll(selector);
			for (var i = 0; i < result.length; i++) {
				$('tr:nth-child(' + (+$(result[i]).attr('data-csstest-row') + 1) + ')').addClass('selected');
			}
		} catch(e) {
			console.log(e);
		}
		if (checkForWelldone(selector)) {
			completeTask();
		}
	};

	$('.selector-value').first().focus().keyup(function (){
		runSelector($(this).val());
	});

	showTask();
});
