{extends file="template.tpl"}

{block name="head"}

<link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/smoothness/jquery-ui.css" />
<link rel="stylesheet" type="text/css" href="{$homepage}/css/jquery.datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="{$homepage}/css/jquery-ui-slider-pips.css">

{/block}

{block name="jumbotron"}

<h1>VOA Tour Reservations</h1>
<p>Tours of the VOA radio and television studios in Washington are available to the public. It's a fascinating look at the largest U.S. international broadcast operation.</p>

{/block}

{block name="body"}





<div id="carousel-example-generic" class="carousel slide" data-interval="false" data-wrap="false" data-ride="carousel">
    <!-- Indicators -->
    <ol class="carousel-indicators">
        <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
        <li data-target="#carousel-example-generic" data-slide-to="1"></li>
        <li data-target="#carousel-example-generic" data-slide-to="2"></li>
        <li data-target="#carousel-example-generic" data-slide-to="3"></li>
        <li data-target="#carousel-example-generic" data-slide-to="4"></li>
    </ol>

    <!-- Wrapper for slides -->
    <div class="carousel-inner" role="listbox">
        <div class="item active" data-id="0">
            {include file="form_slide1.tpl"}
        </div>
        <div class="item" data-id="1">
            {include file="form_slide2.tpl"}
        </div>
        <div class="item" data-id="2">
            {include file="form_slide3.tpl"}
        </div>
        <div class="item" data-id="3">
            {include file="form_slide4.tpl"}
        </div>
        <div class="item" data-id="4">
            {include file="form_slide5.tpl"}
        </div>
    </div>

    <!-- Controls -->
    <a class="left carousel-control hidden-xs" href="#carousel-example-generic" role="button" data-slide="prev">
        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="right carousel-control hidden-xs" href="#carousel-example-generic" role="button" data-slide="next">
        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>

<nav class="visible-xs-block">
  <ul class="pager">
    <li class="previous"><a href="#"><span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span> Go Back</a></li>
    <li class="next"><a href="#">Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a></li>
  </ul>
</nav>

{/block}

{block name="footer"}

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="{$homepage}/js/bootstrap.min.js"></script>
<script src="{$homepage}/js/moment.min.js"></script>
<script src="{$homepage}/js/jquery.datetimepicker.js"></script>
<script src="{$homepage}/js/jquery-ui-slider-pips.min.js"></script>

<script type="text/javascript">

function Form_Payload() {
    this.data = {
        "number_of_visitors": { label: "Number of visitors", value: 1 },
        "type_of_tour": { label: "Type of tour", value: "Daily" },
        "tour_date": { label: "Tour date", value: null },
        "organizer_name": { label: "Organizer's name", value: null },
        "organizer_phone": { label: "Organizer's phone number", value: null },
        "organizer_email": { label: "Organizer's email address", value: null },
        "guests": { label: "Guests", list: true, value: [] },
        "interests": { label: "How did you hear about VOA tour", value: null },
        "notes": { label: "Notes", value: null }
    };
}

Form_Payload.prototype.getJSON = function() {
    var r = {};
    for( var k in this.data )(function(k, v) {
        if( v.value == null) v.value = "n/a";
        r[k] = v.value;
    })(k, this.data[k]);
    return( r );
}

Form_Payload.prototype.slideChanged = function(id) {
    if( id == 0 ) {
        $(".left.carousel-control").hide();
        $("li.previous").hide();
    }
    if( id == 4 ) {
        $(".right.carousel-control").hide();
        $("li.next").hide();
    }

    if( id >= 1 ) {
        $(".left.carousel-control").show();
        $("li.previous").show();
    }

    if( id <= 3 ) {
        $(".right.carousel-control").show();
        $("li.next").show();
    }
}

Form_Payload.prototype.Set = function( key, value, that ) {

    if(
        typeof this.data[key].list != "undefined" &&
        this.data[key].list != "undefined" === true
    ) {
        var array_key = $(that).attr("key");
        this.data[key].value[array_key] = value;
    } else {
        this.data[key].value = value;
    }

    this.Recap();
}

Form_Payload.prototype.resize_other_guests = function() {
    var requested = this.data["number_of_visitors"].value - 2;
    var count = $("#other_guests input").length;

    $("#other_guests .input-group").show();
    $("#other_guests .input-group:gt(" + parseInt(requested) + ")").hide();
}

Form_Payload.prototype.Recap = function() {
    var ul = [];
    for( var k in this.data )(function(k, v) {
        if( typeof v.value === "undefined" ) return(false);

        // single-value key
        if( v.value == null ) v.value = "n/a";
        ul.push( v.label + ": " + v.value);
    })(k, this.data[k]);

    this.resize_other_guests();

    $("#recap").html("<ul><li>" + ul.join("</li><li>") + "</li></ul>");
}

var VOA_form = new Form_Payload();
var reservation_range = {$reservation_range|json_encode};

jQuery(function($){

    var fragment = $("#other_guests").html();

    // variable guest size
    for( var i = 3; i <= 20; i++ )(function(count) {
        $("#other_guests").append( fragment );
        $("#other_guests span:last").html(count);
    })(i);

    // update key hints
    $("#other_guests input").each(function(k,v) {
        $(this).attr("key", k);
    });

    $("#groupSize").slider({ min: 1, max: 20, range: false });
    $("#groupSize").slider("pips" , {
        rest: "label"
    }).on( "slide", function( event, ui ) {
        VOA_form.Set("number_of_visitors", ui.value);
        $("#groupSizeMobile").val(ui.value);

        jQuery('#datetimepicker3').datetimepicker(picker_options);
    });

    $("#groupSizeMobile").on("change", function() {
        var value = parseInt($(this).val());
        VOA_form.Set("number_of_visitors", value );
        $("#groupSize").slider("value", value );

        jQuery('#datetimepicker3').datetimepicker(picker_options);
    });

    function update_date(cal, day, disable) {
        var d = day.split("-");

        var selector =
            ".xdsoft_date" +
            "[data-year='" + parseInt(d[0]) + "']" +
            "[data-month='" + (parseInt(d[1])-1) + "']" + // gah, month-1
            "[data-date='" + parseInt(d[2]) + "']";

        var x = $(cal).find(selector);

        if( disable === true ) {
            x.addClass("xdsoft_disabled");
        } else {
            x.removeClass("xdsoft_disabled");
        }
    }

    function datepicker_generate(that, ct) {
        // disable weekends
        $(that).find('.xdsoft_date.xdsoft_weekend').addClass('xdsoft_disabled');

        var cal = that;

        if( VOA_form.data.type_of_tour.value === "Daily" ) {
            for( var k in reservation_range.days.reserved)(function(day, count) {
                update_date(cal, day, false);
                if( 20 - count - VOA_form.data.number_of_visitors.value < 0 ) {
                    update_date(cal, day, true);
                }
            })(k, reservation_range.days.reserved[k])
        }

        // blocked-off dates are non-negotiable
        for( var k in reservation_range.days.closed)(function(day, count) {
            update_date(cal, day, true);
        })(k, reservation_range.days.closed[k])
    }

    var picker_options = {
        onGenerate:function( ct ){
            datepicker_generate(this, ct);
        },
        formatDate:'Y-m-d',
        format:'YYYY-MM-DD',
        minDate:'{$reservation_range.start|date_format:"Y-m-d"}',
        maxDate:'{$reservation_range.end|date_format:"Y-m-d"}',
        timepicker:false,
        dayOfWeekStart: 0,
        inline:true,
        lang:'en',
        formatTimeScroller: 'g:i A',
        onSelectDate: function(ct, $input) {
            VOA_form.Set("tour_date", ct.dateFormat('Y-m-d') );
        }
    };

    jQuery('#datetimepicker3').datetimepicker(picker_options);

    $("button.tour_type").click(function() {
        $("button.tour_type").removeClass("btn-success");
        $(this).addClass("btn-success");
        var value = $(this).attr("data-type");
        VOA_form.Set("type_of_tour", value);
        $(".right.carousel-control").show();

        // update calendar, because different rules apply
        jQuery('#datetimepicker3').datetimepicker(picker_options);

        if( value === "Daily" ) {
            $("#tourType1").prop('checked', true)
        } else {
            $("#tourType2").prop('checked', true)
        }
    });

    $("#tourType1").click(function() {
        VOA_form.Set("type_of_tour", "Daily");
        $("button.tour_type:eq(0)").click();

        // update calendar, because different rules apply
        jQuery('#datetimepicker3').datetimepicker(picker_options);
    });

    $("#tourType2").click(function() {
        VOA_form.Set("type_of_tour", "Special");
        $("button.tour_type:eq(1)").click();

        // update calendar, because different rules apply
        jQuery('#datetimepicker3').datetimepicker(picker_options);
    });

    $(".carousel").on('slid.bs.carousel', function() {
        var id = parseInt( $("div.item.active").attr("data-id") );
        VOA_form.slideChanged( id );
    });

    // sm
    $(".previous a").click( function(event) {
        event.preventDefault();
        $(".carousel").carousel('prev');
    });

    $(".next a").click( function(event) {
        event.preventDefault();
        $(".carousel").carousel('next');
    });

    // multiples, keyed with data-id
    $(".organizer_info").on("change", function() {
        var k = $(this).attr("data-id");
        var v = $(this).val();

        VOA_form.Set(k, v, this);
    });

    function status_message(message, good) {
        if( good === true ) {
            $("#status_reply")
                .addClass("bg-success")
                .removeClass("bg-danger")
            ;
        } else {
            $("#status_reply")
                .removeClass("bg-success")
                .addClass("bg-danger")
            ;
        }
        $("#status_reply").html( message );
    }

    $("#send_request").click( function() {
        var that = this;

        status_message("", true);
        $("li.previous").hide();

        $(that).prop("disabled", true);
        $.ajax({
            url: "{$homepage}/visit/request",
            method: "post",
            dataType: "json",
            data: VOA_form.getJSON(),
            success: function(data) {
                status_message( data.message, (data.status === "good" ? true : false) );
                if( data.status !== "good" ) {
                    $(that).prop("disabled", false);
                    $("li.previous").show();
                } else {
                    $("li.previous").hide();
                }
            },
            error: function(err) {
                status_message("Error: unable to send a reservation request.<br/>Please call (202) 203-4990 to arrange a tour.", false);
                $(that).prop("disabled", false);
                $("li.previous").show();
            }
        });
    });

    // init state
    $(".left.carousel-control").hide();
    $("li.previous").hide();
    $("button.tour_type:eq(0)").click();
    // $("li.next").hide();
    $(".right.carousel-control").hide();


});

</script>

{/block}
