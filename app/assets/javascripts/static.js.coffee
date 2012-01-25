class Builder
    current_date: null
    constructor: ->
        date = new Date()
        @current_date = date
        $("#date_header")[0].innerText = @current_date.toLocaleDateString()
        $(".best_in_place").best_in_place()
        $("#sortable").sortable({
            update: () -> 
                task_data = "task_list" : $(this).sortable('toArray')           
                $.ajax
                    url: "/tasks/sort"
                    type: "POST"
                    data: task_data
        })
        $("#sortable").bind "update", () -> 
            task_data = "task_list" : $("#sortable").sortable('toArray')           
            $.ajax
                url: "/tasks/sort"
                type: "POST"
                data: task_data
        $("#sortable").sortable().trigger("sortupdate")
        $("#add_task").on "click", () -> new Task
        for task in $("#task_area").find(".task")
            new Task task   
        $(window).on "keyup", (e) => 
            if e.keyCode == 37

                newDate = new Date()
                newDate.setDate(@current_date.getDate() - 1)
                @current_date = newDate
                params = 
                    "date": @current_date.toLocaleString()
                $.ajax
                    url: "tasks/get_tasks_completed_on_date"
                    type: "POST"
                    data: params 
                    success: (e) -> console.log e               
                $("#task_area").show('slide', {direction: 'left'}, 400)
                $("#date_header")[0].innerText = @current_date.toLocaleDateString()
            else if e.keyCode == 39
                newDate = new Date()
                newDate.setDate(@current_date.getDate() + 1)
                @current_date = newDate
                params = 
                    "date": @current_date.toLocaleString()
                $.ajax
                    url: "tasks/get_tasks_completed_on_date"
                    type: "POST"
                    data: params 
                    success: (e) -> console.log e                 
                $("#task_area").show('slide', {direction: 'right'}, 400)
                $("#date_header")[0].innerText = @current_date.toLocaleDateString()


class Task
    constructor: (task) ->
        if task
            if $(task).find(".task_checkbox").attr "checked"
                $(task).find(".best_in_place").css("text-decoration", "line-through")
            @addListeners(task)
        else
            $.ajax
                url: "/tasks"
                type: "POST"
                data: "position" : 0
                success: (e) =>
                    task = $("#task_template").clone()
                    $(task).find("span").attr "data-url", "/tasks/#{e}"
                    $(task).find("span").attr "id", "best_in_place_task_#{e}_name"
                    $(task).attr("id", "task_#{e}")
                    $(task).attr("task_id", e)
                    $("#sortable").prepend task
                    $(".best_in_place").best_in_place()
                    $($(task).find(".best_in_place")[0]).text("new task")
                    @addListeners(task)
                    $(task).find(".best_in_place").trigger("click") 
                    $(task).find("input").last().focus()
    addListeners: (task) ->
        $(task).on "dblclick", (e) -> 
            sourceTask = $(e.srcElement)
            sourceTask.fadeOut(300, () ->
                $("#sortable").prepend sourceTask
                sourceTask.fadeIn(300, () ->
                    $("#sortable").trigger "update"
                )
            )
        $(task).hover(
            () -> $(task).css("background", "#F4F4F4"), 
            () -> $(task).css("background", "#F9F9F9")
        )            
        $(task).find(".delete_label").on "click", (e) => 
            $.ajax
                url: "/tasks/#{$(task).attr "task_id"}"
                type: "DELETE"
                success: () => $(task).fadeOut(500)
        $(task).on "keydown", (e) -> if e.keyCode == 9 then new Task
        $(task).find(".task_checkbox").on "click", (e) ->
            task_area = $(task).find(".best_in_place")
            if task_area.css("text-decoration") == "none"
                sourceTask = $(e.srcElement).parent("li")
                sourceTask.fadeOut(500, () ->
                    $("#sortable").append sourceTask
                    sourceTask.fadeIn(500, () -> 
                        $("#sortable").trigger "update"
                    )
                )
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