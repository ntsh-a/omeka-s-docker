{
  // For more info about adding and configuring languages in Mirador, see: 
  // https://github.com/ProjectMirador/mirador/wiki/M3-Internationalization-(i18n) 
  language: 'en', // Set default language display here. 
  availableLanguages: { // All the languages available in the language switcher
    en: 'English',
  },
  window: {
    allowClose: false,
	  defaultSideBarPanel: 'attribution',
	  sideBarOpenByDefault: true,
    panels: { // Configure which panels are visible in WindowSideBarButtons
      info: false,
      attribution: true,
      canvas: true,
      annotations: true,
      search: true,
      layers: true,
    },
  },
  workspace: {
	  showZoomControls: true,
    allowNewWindows: false,
    type: 'mosaic', // Which workspace type to load by default. Other possible values are "elastic"
  },
  workspaceControlPanel: {
    enabled: false,
  },
  thumbnailNavigation: {
    defaultPosition: 'far-bottom', // Which position for the thumbnail navigation to be be displayed. Other possible values are "far-bottom" or "far-right"
    displaySettings: true, // Display the settings for this in WindowTopMenu
    height: 130, // height of entire ThumbnailNavigation area when position is "far-bottom"
    showThumbnailLabels: true, // Configure if thumbnail labels should be displayed
    width: 100, // width of one canvas (doubled for book view) in ThumbnailNavigation area when position is "far-right"
  },
  export: {
    catalog: false,
    companionWindows: true,
    config: true,
    elasticLayout: true,
    layers: true,
    // filter out anything re-retrievable:
    manifests: { filter: ([id, value]) => !id.startsWith('http') },
    viewers: true,
    windows: true,
    workspace: true,
  },
}
