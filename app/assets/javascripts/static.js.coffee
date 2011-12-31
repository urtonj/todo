# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Builder
    constructor: ->
        for task in $("#task_area").find(".task")
            new Task task

class Task
    constructor: (task) ->
        if task
            $(task).hover(
                () -> $(task).css("opacity", 1), 
                () -> $(task).css("opacity", .9)
            )
            $(task).find(".task_checkbox").on "click", () ->
                task_area = $(task).find(".best_in_place")
                if task_area.css("text-decoration") == "none"
                    $(task_area).css("text-decoration", "line-through")
                else 
                    $(task_area).css("text-decoration", "none")
        else
            new_task = $("#task_template").clone()
            $("#sortable").prepend new_task
            $(new_task).find(".task").focus()
            $(new_task).on "keydown", (e) ->
                if e.keyCode == 13
                    task_data = 
                        "task":
                            name: $(new_task).find(".task")[0].value
                    #$.ajax
                    #    type: "POST"
                    #    url: "/tasks"
                    #    data: task_data
                    #    success: (e) =>
                    #        console.log e
                    #    data



$ -> 
    $(".best_in_place").best_in_place()
    $("#sortable").sortable()
    $("#add_task").on "click", () -> new Task
    new Builder