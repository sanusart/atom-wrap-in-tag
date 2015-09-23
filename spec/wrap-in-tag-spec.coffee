WrapInTag = require '../lib/wrap-in-tag'

describe "WrapInTag", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('wrap-in-tag')

  describe "when the wrap-in-tag:wrap event is triggered", ->
    it "Check correct tag around word", ->
