controladdin "HTML"
{
    StartupScript = 'js/startup.js';
    Scripts = 'js/script.js';
    StyleSheets = 'js/style.css';
    HorizontalStretch = false;
    VerticalStretch = false;
    RequestedHeight = 200;
    RequestedWidth = 200;

    event ControlReady();

    procedure Render(html: Text)
}