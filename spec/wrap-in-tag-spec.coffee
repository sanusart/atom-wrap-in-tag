describe "atom wrap in tag", ->

  [workspaceElement, activationPromise] = []

  packageLoaded = (callback) ->
    atom.commands.dispatch(workspaceElement, 'wrap-in-tag:wrap')
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->

    activationPromise = atom.packages.activatePackage('atom-wrap-in-tag')
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise ->
      atom.workspace.open './test.html'

  it 'Should check if "atom-wrap-in-tag" package is loaded', ->
    packageLoaded ->
      expect(atom.packages.loadedPackages["atom-wrap-in-tag"]).toBeDefined()

  describe "When file is loaded", ->
    it "should have test.html opened in an editor", ->
      expect(atom.workspace.getActiveTextEditor().getText().trim()).toBe """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      """

  describe "When file have selection", ->
    it "Should have 'ipsum dolor' selected", ->
      atom.workspace.getActiveTextEditor().setSelectedBufferRange [[0, 6], [0, 17]]
      atom.commands.dispatch atom.views.getView(atom.workspace), 'wrap-in-tag:wrap'
      expect(atom.workspace.getActiveTextEditor().getText().trim()).toBe """
        Lorem <p>ipsum dolor</p> sit amet, consectetur adipiscing elit.
      """
