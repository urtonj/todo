class Builder
    constructor: ->
        $(".best_in_place").best_in_place()
        $("#sortable").sortable({
            update: () -> 
                task_data = "task_list" : $(this).sortable('toArray')           
                $.ajax
                    url: "/tasks/sort"
                    type: "POST"
                    data: task_data
        })
        $("#add_task").on "click", () -> new Task
        for task in $("#task_area").find(".task")
            new Task task              

class Task
    constructor: (task) ->
        if task
            if $(task).find(".task_checkbox").attr "checked"
                $(task).find(".best_in_place").css("text-decoration", "line-through")
            $(task).hover(
                () -> $(task).css("background", "#F4F4F4"), 
                () -> $(task).css("background", "#F9F9F9")
            )
            @addListeners(task)
        else
            $.ajax
                url: "/tasks"
                type: "POST"
                data: "position" : $("#sortable").sortable('toArray').length + 1
                success: (e) =>
                    task = $("#task_template").clone()
                    $(task).find("span").attr "data-url", "/tasks/#{e}"
                    $(task).find("span").attr "id", "best_in_place_task_#{e}_name"
                    $(task).attr("id", "task_#{e}")
                    $(task).attr("task_id", e)
                    task.appendTo $("#sortable")
                    $(".best_in_place").best_in_place()
                    $($(task).find(".best_in_place")[0]).text("new task")
                    @addListeners(task)
                    $(task).find(".best_in_place").trigger("click") 
                    $(task).find("input").last().focus()
                    $(task).hover(
                        () -> $(task).css("background", "#F4F4F4"), 
                        () -> $(task).css("background", "#F9F9F9")
                    )                    
    addListeners: (task) ->
        $(task).find(".delete_label").on "click", (e) => 
            $.ajax
                url: "/tasks/#{$(task).attr "task_id"}"
                type: "DELETE"
                success: () => $(task).hide()
        $(task).on "keydown", (e) -> if e.keyCode == 9 then new Task
        $(task).find(".task_checkbox").on "click", (e) ->
            task_area = $(task).find(".best_in_place")
            if task_area.css("text-decoration") == "none"
                $(task_area).css("text-decoration", "line-through")
                task_data = 
                    "task_id": $(e.srcElement).parent().attr "task_id"
                    "completed": true                
            else 
                $(task_area).css("text-decoration", "none")
                task_data = 
                    "task_id": $(e.srcElement).parent().attr "task_id"
                    "completed": false                
            $.ajax
                url: "/tasks/update_completed"
                type: "POST"            
                data: task_data
            

$ -> new Builder
    