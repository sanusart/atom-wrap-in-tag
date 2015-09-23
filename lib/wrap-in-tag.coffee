module.exports =

  activate: (state) ->

    atom.commands.add 'atom-workspace', 'wrap-in-tag:wrap': => @wrap()

  wrap: ->

    tag = 'p'

    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      tagRangePos = editor.getSelectedBufferRange()

      newText = ['<', tag, '>', selection, '</', tag, '>'].join('')
      newStartTagSelectRange = [[tagRangePos.start.row, tagRangePos.start.column+1],[tagRangePos.start.row, tagRangePos.start.column+2]]
      newEndTagSelectRange = [[tagRangePos.end.row, tagRangePos.end.column+5],[tagRangePos.end.row, tagRangePos.end.column+6]]

      editor.insertText(newText)
      editor.setCursorBufferPosition([tagRangePos.start.row, tagRangePos.start.column+1])
      editor.addSelectionForBufferRange(newStartTagSelectRange)
      editor.addSelectionForBufferRange(newEndTagSelectRange)

      # console.log 'selection', selection, newText, tagRangePos
      # console.log 'newStartTagSelectRange', newStartTagSelectRange
      # console.log 'newEndTagSelectRange', newEndTagSelectRange
