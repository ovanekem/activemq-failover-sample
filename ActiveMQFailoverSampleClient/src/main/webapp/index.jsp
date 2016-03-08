<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Knoware ActiveMQ Failover Sample</title>

    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<c:url var="home" value="/" scope="request"/>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">ActiveMQ Failover Sample</a>
        </div>
    </div>
</nav>

<div class="jumbotron">
    <div class="container">
        <h2>Welcome to this sample demonstrating ActiveMQ failover</h2>
        <h3>Choose one of the actions below...</h3>
        <p>
            <a class="btn btn-default" href="#" role="button" onclick="toggleForm();">Enqueue Messages</a>
            <a class="btn btn-default" href="#" role="button" onclick="toggleList();">Dequeue Messages</a>

        </p>
    </div>
</div>

<div id="enqueueMessages" class="container">
    <h2>Enqueue messages</h2>
    <br>

    <form class="form-horizontal" id="add-form">
        <div class="form-group form-group-lg">
            <label class="col-sm-2 control-label">Number of messages to enqueue</label>
            <div class="col-sm-10">
                <input type=text class="form-control" id="numberMessages" value="100">
            </div>
        </div>
        <div class="form-group form-group-lg">
            <label class="col-sm-2 control-label">Message text to enqueue</label>
            <div class="col-sm-10">
                <input type=text class="form-control" id="textMessage" value="This is my text">
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" id="btn-add"
                        class="btn btn-primary btn-lg">Enqueue messages
                </button>
            </div>
        </div>
    </form>
</div>

<div id="feedback"></div>

<div id="listMessages" class="container">
    <table id='messages' border="1"></table>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

<script type="application/javascript">
    $(document).ready(function () {
        $("#listMessages").hide();
        $("#enqueueMessages").hide();

        $("#enqueueMessages").submit(function (event) {
            enableEnqueueButton(false);


            // Prevent the form from submitting via the browser.
            event.preventDefault();

            enqueueMessages();

        });
    });
    function enableEnqueueButton(flag) {
        $("#btn-add").prop("disabled", flag);
    }

    function enqueueMessages() {

        var message = {}
        message["number"] = $("#numberMessages").val();
        message["text"] = $("#textMessage").val();
        $("#feedback").hide();

        $.ajax({
            type: "POST",
            contentType: "application/json",
            url: "messages/enqueue",
            data: JSON.stringify(message),
            dataType: 'json',
            timeout: 100000,
            success: function (data) {
                console.log("SUCCESS: ", data);
                display(data);
            },
            error: function (e) {
                console.log("ERROR: ", e);
                display(e);
            },
            done: function (e) {
                console.log("DONE");
                enableEnqueueButton(true);
            }
        });
    }
    function display(data) {
        var json = "<h4>Ajax Response</h4><pre>"
                + JSON.stringify(data, null, 4) + "</pre>";
        $('#feedback').html(json);
        $("#feedback").show();

    }
    function toggleList() {
        $("#listMessages").show();
        $("#enqueueMessages").hide();
        $("#messages tbody").remove();
        $("#feedback").hide();


        $.ajax({
            type: "GET",
            contentType: "application/json",
            url: "messages/list",
            dataType: 'json',
            timeout: 100000,
            success: function (data) {
                console.log("SUCCESS: ", data);
                for (var i = 0; i < data.length; i++) {
                    var id = data[i].id;
                    var text = data[i].text;

                    $('#messages').append('<tr><td> ' + id + ' </td> <td> ' + text + '</td></tr>');
                }
                display("Retrieved list with success");
            },
            error: function (e) {
                console.log("ERROR: ", e);
                display("Error: " + e);
            },
            done: function (e) {
                console.log("DONE");
            }
        });
    }
    function toggleForm() {
        $("#listMessages").hide();
        $("#enqueueMessages").show();
        $("#feedback").hide();

    }

</script>
</body>
</html>