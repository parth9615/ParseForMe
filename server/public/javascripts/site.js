// call this from the developer console and you can control both instances
var calendars = {};

$(document).ready( function() {

  // assuming you've got the appropriate language files,
  // clndr will respect whatever moment's language is set to.
  // moment.locale('ru');

  // here's some magic to make sure the dates are happening this month.
  var thisMonth = moment().format('YYYY-MM');

  //get request to get events from api
  //store resopnse

  var eventArray = [ ];

  var qs = encodeURIComponent("where\={\"username\":\""+document.cookie.split('=')[1].toLowerCase()+"\"}");
  var getEvents = $.ajax({
      type: 'GET',
      url: "https://api.parse.com/1/classes/Events?"+qs,

      headers: {
           'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
           'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF'
      },
      success: function(data){
        console.log(data);
        for(var i=0; i<data.results.length; i++){
          var dateArray = data.results[i].events.Date.split("/");
          console.log(dateArray);
          ymdDate = dateArray[2]+'-'+ (dateArray[0].length == 2 ? dateArray[0] : '0'+dateArray[0])+'-'+(dateArray[1].length == 2 ? dateArray[1] : '0'+dateArray[1]);
          eventArray.push({ date: ymdDate, title: data.results[i].events.Description  });
      }
    }
  });

  getEvents.done( function(){



  // the order of the click handlers is predictable.
  // direct click action callbacks come first: click, nextMonth, previousMonth, nextYear, previousYear, or today.
  // then onMonthChange (if the month changed).
  // finally onYearChange (if the year changed).

  calendars.clndr1 = $('.cal1').clndr({
    events: eventArray,
    // constraints: {
    //   startDate: '2013-11-01',
    //   endDate: '2013-11-15'
    // },
    clickEvents: {
      click: function(target) {

        //MAGIC

        $("#here_table table").remove();
        console.log(target['events'].length);
       // alert(typeof(target['events'][0]['title']))

       console.log(target.date._i);
       if (target['events'].length >= 1) {
         var content = "<table id='smokeShow'>"
         content += "<tr><th id='smokeShowTh'><u>" + 'Event(s) Happening on ' + target.date._i + '</u></th></tr>';
         for(var i=0; i<target['events'].length; i++){
           content += "<tr><td id='smokeShowTd'>" + target['events'][i]['title'] + '</td></tr>';
         }
         content += "</table>"

         $('#here_table').append(content);
       }




        // if you turn the `constraints` option on, try this out:
        // if($(target.element).hasClass('inactive')) {
        //   console.log('not a valid datepicker date.');
        // } else {
        //   console.log('VALID datepicker date.');
        // }
      },
      nextMonth: function() {
        console.log('next month.');
      },
      previousMonth: function() {
        console.log('previous month.');
      },
      onMonthChange: function() {
        console.log('month changed.');
      },
      nextYear: function() {
        console.log('next year.');
      },
      previousYear: function() {
        console.log('previous year.');
      },
      onYearChange: function() {
        console.log('year changed.');
      }
    },
    multiDayEvents: {
      startDate: 'startDate',
      endDate: 'endDate',
      singleDay: 'date'
    },
    showAdjacentMonths: true,
    adjacentDaysChangeMonth: false
  });
});
  // calendars.clndr2 = $('.cal2').clndr({
  //   template: $('#template-calendar').html(),
  //   events: eventArray,
  //   multiDayEvents: {
  //     startDate: 'startDate',
  //     endDate: 'endDate',
  //     singleDay: 'date'
  //   },
  //   lengthOfTime: {
  //     days: 14,
  //     interval: 7
  //   },
  //   clickEvents: {
  //     click: function(target) {
  //       console.log(target);
  //     }
  //   }
  // });

  // calendars.clndr2 = $('.cal3').clndr({
  //   template: $('#template-calendar-months').html(),
  //   events: eventArray,
  //   multiDayEvents: {
  //     startDate: 'startDate',
  //     endDate: 'endDate'
  //   },
  //   lengthOfTime: {
  //     months: 2,
  //     interval: 1
  //   },
  //   clickEvents: {
  //     click: function(target) {
  //       console.log(target);
  //     }
  //   }
  // });

  // // bind both clndrs to the left and right arrow keys
  // $(document).keydown( function(e) {
  //   if(e.keyCode == 37) {
  //     // left arrow
  //     calendars.clndr1.back();
  //     calendars.clndr2.back();
  //   }
  //   if(e.keyCode == 39) {
  //     // right arrow
  //     calendars.clndr1.forward();
  //     calendars.clndr2.forward();
  //   }
  // });

});
