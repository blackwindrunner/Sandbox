dependencies = {
    layers: [
		{
			name: "dojo.js",
			dependencies: [
				"dojo.parser",
				"dojo.i18n",
				"dojo.data.ItemFileReadStore",
				"dojo.data.ItemFileWriteStore",
				"dijit._Widget",
				"dijit._Templated",
				"dijit.form.Form",
				"dijit.form.Button",
				"dijit.form.CheckBox",
				"dijit.form.ComboBox",
				"dijit.form.ValidationTextBox",
				"dijit.form.CurrencyTextBox",
				"dijit.form.DateTextBox",
				"dijit.form.NumberTextBox",
				"dijit.form.RadioButton",
				"dijit.form.FilteringSelect",
				"dijit.form.SimpleTextarea",
				"dijit.form.TextBox",
				"dijit.Editor",
				"dijit.Tree",
				"dijit.tree.ForestStoreModel",
				"dijit.Dialog",
				"dijit.layout.TabContainer",
				"dijit.layout.ScrollingTabController",
				"dijit.layout.TabController",
				"dijit.layout.ContentPane",
				
				"dojox.grid.cells.dijit",
				"dojox.grid.EnhancedGrid",
				"dojox.form.FileUploader",
				"dojox.grid.enhanced.plugins.Pagination",
				"dojox.grid.enhanced.plugins.IndirectSelection",
				"dojox.grid.enhanced.plugins.NestedSorting",
				"dojox.data.QueryReadStore"
				
			]
		},
		{
			name: "../com/ibm/btt/btt.js",
			dependencies: [
				"com.ibm.btt.dijit.Anchor",
				"com.ibm.btt.dijit.Button",
				"com.ibm.btt.dijit.CheckBox",
				"com.ibm.btt.dijit.ComboBox",
				"com.ibm.btt.dijit.CurrencyTextBox",
				"com.ibm.btt.dijit.DateTextBox",
				"com.ibm.btt.dijit.Form",
				"com.ibm.btt.dijit.Image",
				"com.ibm.btt.dijit.Label",
				"com.ibm.btt.dijit.NumberTextBox",
				"com.ibm.btt.dijit.RadioButton",
				"com.ibm.btt.dijit.RichTextEditor",
				"com.ibm.btt.dijit.Select",
				"com.ibm.btt.dijit.StringTextBox",
				"com.ibm.btt.dijit.TextArea",
				"com.ibm.btt.dijit.Tree",
				"com.ibm.btt.dijit.ValidationTextBox",
				"com.ibm.btt.event.Engine",
				"com.ibm.btt.dijit.GridDijit",
				"com.ibm.btt.dijit.Grid",
				"com.ibm.btt.dijit.Message",
				"com.ibm.btt.dijit.FileUpload",
				"com.ibm.btt.dijit.Group",
				"com.ibm.btt.dijit.TabbedPane",
				"com.ibm.btt.dijit.ContentPane",
				"com.ibm.btt.dijit.Hidden",
				"com.ibm.btt.event.BaseMonitor",
				"com.ibm.btt.dijit.GridComparer",
				"com.ibm.btt.event.ConsoleMonitor"
			],
			layerDependencies :[
				"dojo.js"
			]
		}	
    ],

    prefixes: [
		["dojox", "../dojox"],
		["dijit","../dijit"],
		["com","../com"]
    ]
}
