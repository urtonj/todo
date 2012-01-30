class List
    list_date: null
    current_date: null
    constructor: ->
        self = @
        [@list_date, @current_date] = [new Date(), new Date()]
        for task in $("#task_area").find(".task")
            new Task task           
        @updateDateText(@list_date)
        $(".best_in_place").best_in_place()
        $("#sortable").sortable({
            update: () -> 
                task_data = "task_list" : $(this).sortable('toArray')           
                self.updateListOrder(task_data)
        })
        $("#sortable").bind "update", () -> 
            task_data = "task_list" : $("#sortable").sortable('toArray')  
            self.updateListOrder(task_data)         
        $("#sortable").sortable().trigger("sortupdate")
        $("#add_task").on "click", () -> new Task
        $(window).on "keyup", (e) => 
            return if $(e.srcElement).is("input")
            if e.keyCode == 37
                @list_date.setDate(@list_date.getDate() - 1)
                @changeDate("left")
            else if e.keyCode == 39
                @list_date.setDate(@list_date.getDate() + 1)
                @changeDate("right")
    updateListOrder: (list) =>
        $.ajax
            url: "/tasks/sort"
            type: "POST"
            data: list
    updateDateText: (text) => 
        $("#date_header")[0].innerText = text.toLocaleDateString()
    changeDate: (direction) =>
        if @current_date.getDate() == @list_date.getDate()
            $.ajax
                url: "tasks/get_current_tasks"
                type: "GET"
                success: (e) =>
                    @updateList(e)
        else
            params = 
                "date": @list_date.toLocaleString()
            $.ajax
                url: "tasks/get_tasks_completed_on_date"
                type: "POST"
                data: params 
                success: (e) => 
                    @updateList(e)
        @updateDateText(@list_date)
    updateList: (list) => 
        @clearList()
        @populateList(list)
    clearList: () => 
        $("#sortable").find("li").hide()#fadeOut(150)
    populateList: (list) =>
        for task in list
            new Task task.name, task.id, task.completed_at


class Task
    constructor: (task, id, completed) ->
        if typeof(task) == "object"
            if $(task).find(".task_checkbox").attr "checked"
                $(task).find(".best_in_place").css("text-decoration", "line-through")
            @addListeners(task)
        else if typeof(task) == "string"
            new_task = $($("#task_template").clone())
            new_task.hide()
            new_task.find("span").attr "data-url", "/tasks/#{id}"
            new_task.attr("id", "task_#{id}")
            new_task.attr("task_id", id)
            $("#sortable").prepend new_task
            $(".best_in_place").best_in_place()
            $(new_task.find(".best_in_place")[0]).text(task)
            @addListeners(new_task)
            new_task.find(".best_in_place").css("text-decoration", "line-through") if completed
            $(new_task).find(".task_checkbox").attr "checked", "checked" if completed
            $(new_task).fadeIn(150)
        else if typeof(task) == "undefined"
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
            if $(e.srcElement).is("li")
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
            

$ -> new List