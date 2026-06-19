// Function to add a legend to the Leaflet map
function addLegend(map) {
    const legend = L.control({ position: 'bottomright' });

    legend.onAdd = function (map) {
        const div = L.DomUtil.create('div', 'info legend');
        div.innerHTML += '<h4>Risiko Banjir</h4>';
        
        const grades = ['Tinggi', 'Sedang', 'Rendah'];
        const colors = ['#ef4444', '#f59e0b', '#10b981'];

        for (let i = 0; i < grades.length; i++) {
            div.innerHTML +=
                '<i style="background:' + colors[i] + '"></i> ' +
                grades[i] + '<br>';
        }
        
        div.innerHTML += '<hr style="margin:8px 0; border: 0; border-top: 1px solid rgba(0,0,0,0.1);">';
        div.innerHTML += '<h4>Lainnya</h4>';
        div.innerHTML += '<i style="background:#0ea5e9"></i> Zona Tsunami<br>';
        div.innerHTML += '<i style="background:#8b5cf6; border-radius: 50%;"></i> Pengungsian<br>';

        return div;
    };

    legend.addTo(map);
}
