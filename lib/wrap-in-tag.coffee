module.exports =

  activate: (state) ->

    atom.commands.add 'atom-workspace', 'wrap-in-tag:wrap': => @wrap()

  wrap: ->

    tag = 'p'

    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      tagRangePos = editor.getSelectedBufferRange()

      newText = ['<', tag, '>', selection, '</', tag, '>'].join('')

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

      newStartTagSelectRange = [range.start.from, range.start.to]
      newEndTagSelectRange = [range.end.from, range.end.to]

      editor.insertText(newText)
      editor.setCursorBufferPosition([tagRangePos.start.row, tagRangePos.start.column+1])
      editor.addSelectionForBufferRange(newStartTagSelectRange)
      editor.addSelectionForBufferRange(newEndTagSelectRange)

      editorView = atom.views.getView editor
      editorView.addEventListener 'keydown', (event) ->
        if event.keyCode is 32
          if editor.cursors.length > 1
            editor.cursors[1].marker.destroy()
          @removeEventListener 'keydown', arguments.callee;
