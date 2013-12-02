$(document).ready(function(){

  $("body").on("click", ".publish", function(event){
    event.preventDefault();

    var entry_slug_data = {
      slug: $(this).data("entry-slug")
    }

    $.post('/entries/publish', entry_slug_data, function(){});

    $(this).removeClass("btn-success");
    $(this).addClass("btn-warning");
    $(this).text("Published!");

  });

  $(".tweet").click(function(){
   	var title = '"'+$(this).parent(".entry").find("h1").text()+'"'; 
   	var twitter_handle = $("#twitter_handle").text(); 
   	var blogpost_url = "http://"+window.location.host+""+ $(this).parent(".entry").find(".blogpost_url").attr("href"); 
   	var tweet_string = title+ "- Guest post by student " + twitter_handle + blogpost_url; 
   	var data = { tweet: tweet_string };  

   	//console.log(data);

   	$('.tweet_msg').text(tweet_string);

   	//show modal
   	$('#tweet').modal({
   		show: true
   	});

  	$('form').submit(function(event) {

   			//console.log(data);

   			$.post('/users/tweet', data, function(return_data){

   				$('#tweet').modal('hide');
   				console.log(return_data);
   			});

   			event.preventDefault();

   		}); //end form submit

    // $.post('/entries/tweet', entry_slug_data, function(){});

    // $(this).removeClass("btn-success");
    // $(this).addClass("btn-warning");
    // $(this).text("Tweeted!");


  });
});