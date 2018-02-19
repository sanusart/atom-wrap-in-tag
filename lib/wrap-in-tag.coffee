module.exports =

  activate: (state) ->

    atom.commands.add 'atom-workspace', 'wrap-in-tag:wrap': => @wrap()
    atom.commands.add 'atom-workspace', 'wrap-in-tag:wraptag': => @wraptag()

  wrap: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.getSelections().map((item) -> wrapSelection(editor, item, 0))
  wraptag: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.getSelections().map((item) -> wrapSelection(editor, item ,'p'))


wrapSelection = (editor, selection, tag='p') ->
  text = selection.getText()
  tagRangePos = selection.getBufferRange()

  if tag # wrap a html tag:
      newText = ['<', tag, '>', text, '</', tag, '>'].join('')
      range =
        start:
          from: [tagRangePos.start.row, tagRangePos.start.column+1]
          to: [tagRangePos.start.row, tagRangePos.start.column+2]
        end:
          from: [tagRangePos.end.row, tagRangePos.end.column+5],
          to: [tagRangePos.end.row, tagRangePos.end.column+6]

      if range.end.from[0] > range.start.from[0]
        range.end.from[1] = range.end.from[1] - 3
        range.end.to[1] = range.end.to[1] - 3

  else #wrap a quote (or some other text):
    newText = '"'+text+'"'
    range =
        start:
            from: [tagRangePos.start.row, tagRangePos.start.column]
            to: [tagRangePos.start.row, tagRangePos.start.column+1]
        end:
            from: [tagRangePos.end.row, tagRangePos.end.column+1],
            to: [tagRangePos.end.row, tagRangePos.end.column+2]


  newStartTagSelectRange = [range.start.from, range.start.to]
  newEndTagSelectRange = [range.end.from, range.end.to]

  selection.insertText(newText)
  selection.cursor.setBufferPosition([tagRangePos.start.row, tagRangePos.start.column+1])
  editor.addSelectionForBufferRange(newStartTagSelectRange)
  endTagSelection = editor.addSelectionForBufferRange(newEndTagSelectRange)

  editorView = atom.views.getView editor
  editorView.addEventListener 'keydown', (event) ->
    if event.keyCode is 32
      endTagSelection.cursor.marker.destroy()
      @removeEventListener 'keydown', arguments.callee;
