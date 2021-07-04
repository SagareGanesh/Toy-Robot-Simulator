$(document).ready(function() {

  $direction = null
  $rowPosition = null
  $columnPosition = null
  $directionSymbol = null

  $southDirectionSymbol = "&#8681" // ⇩
  $northDirectionSymbol = "&#8679" // ⇧
  $westDirectionSymbol = "&#8678"  // ⇦
  $eastDirectionSymbol = "&#8680"  // ⇨

  $east = "EAST"
  $west = "WEST"
  $south = "SOUTH"
  $north = "NORTH"

  $rotateLeftSignal = "LEFT"
  $rotateRightSignal = "RIGHT"

  $emptyRowColumnValue = ""

  // Rotate Left
  //
  $("#left").click(function(){
    rotate($rotateLeftSignal)
  });

  // Rotate Right
  //
  $("#right").click(function(){
    rotate($rotateRightSignal)
  });

  // Get Direction Symbol
  //
  getDirectionSymbol = (direction) => {
    switch(direction) {
      case $south: return $southDirectionSymbol;
      case $north: return $northDirectionSymbol;
      case $east:  return $eastDirectionSymbol;
      case $west: return $westDirectionSymbol;
    }
  };

  // Rotate
  //
  rotate = (signal) => {
    $.ajax({
      url: "/robot/rotate",
      type: "PUT",
      data: { "signal": signal }
    }).done(function(result){
      updateData(result)
    });
  };

  // Move
  //
  $("#move").click(function(){
    $.ajax({
      url: "/robot/move",
      type: "PUT"
    }).done(function(result){
      updateData(result)
    });
  });

  // Place
  //
  $("#place").click(function(){
    placeRowPosition = $("#row-position").val()
    placeColumnPosition = $("#column-position").val()
    plcaeDirection = $("#direction").val()

    if(placeRowPosition != "" && placeColumnPosition != "" && plcaeDirection != "") {
      $.ajax({
        url: "/robot/place",
        type: "POST",
        data: {
          "robot": {
            "row_position": placeRowPosition,
            "column_position": placeColumnPosition,
            "direction": plcaeDirection
          }
        }
      }).done(function(result){
        updateData(result)
        clearSelection()
      });
    } else {
      alert("Please select Row, Column and Direction!!!")
    }
  });

  // Report
  //
  $("#report").click(function(){
    $.ajax({
      url: "/robot/report",
      type: "GET",
    }).done(function(result){
      rowPosition = result["row_position"]
      columnPosition = result["column_position"]
      direction = result["direction"]

      if(rowPosition && columnPosition && direction) {
        alert(`${rowPosition}, ${columnPosition}, ${direction}`)
      }
    });
  });

  // Update Data
  //
  updateData = (robotData) => {
    placeRowPosition = robotData["row_position"]
    placeColumnPosition = robotData["column_position"]
    plcaeDirection = robotData["direction"]

    if(placeRowPosition != "" && placeColumnPosition != "" && plcaeDirection != "") {
      unfillRowColumnValue()
      updateDirection(plcaeDirection)
      updateDirectionSymbol()
      updateRowColoumnPositions(placeRowPosition, placeColumnPosition)
      fillRowColumnValue()
    }
  }

  // Clear Selection
  //
  clearSelection = () => {
    $("#row-position").prop("value", "")
    $("#column-position").prop("value", "")
    $("#direction").prop("value", "")
  }

  // Fill Row Colum Value
  //
  fillRowColumnValue = () => {
    $(`#${$rowPosition}-${$columnPosition}`).html($directionSymbol);
  }

  // Unfill Row Colum Value
  //
  unfillRowColumnValue = () => {
    $(`#${$rowPosition}-${$columnPosition}`).html($emptyRowColumnValue);
  }

  // Update Row Column Positions
  //
  updateRowColoumnPositions = (rowPosition, columnPosition) => {
    $rowPosition = rowPosition
    $columnPosition = columnPosition
  }

  // Update Direction
  //
  updateDirection = direction => {
    $direction = direction
  }

  // Update Direction Symbol
  //
  updateDirectionSymbol = () => {
    $directionSymbol = getDirectionSymbol($direction)
  }

});
