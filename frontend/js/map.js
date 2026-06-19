// Initialize Leaflet Map
let map;
let layers = {
    wilayah: null,
    banjir: null,
    tsunami: null,
    pengungsian: null
};

document.addEventListener('DOMContentLoaded', () => {
    // Check if we are on the map page
    if (!document.getElementById('map')) return;

    // Center on Jakarta
    map = L.map('map').setView([-6.200000, 106.816666], 11);

    // Basemaps
    const osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    });
    
    const satellite = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
        attribution: 'Tiles &copy; Esri'
    });

    osm.addTo(map);

    const baseMaps = {
        "OpenStreetMap": osm,
        "Satellite": satellite
    };

    L.control.layers(baseMaps).addTo(map);

    // Add Legend
    addLegend(map);

    // Initialize Filters
    initFilters(updateLayers);

    // Setup Layer Toggles
    setupLayerToggles();

    // Initial Load
    loadAllLayers();
});

function getBanjirColor(risiko) {
    switch (risiko) {
        case 'Tinggi': return '#ef4444';
        case 'Sedang': return '#f59e0b';
        case 'Rendah': return '#10b981';
        default: return '#94a3b8';
    }
}

async function loadAllLayers() {
    updateLayers(filters);
    
    // Load Wilayah (Static mostly)
    const wilayahData = await fetchGeoJSON('wilayah');
    if (wilayahData) {
        layers.wilayah = L.geoJSON(wilayahData, {
            style: { color: '#64748b', weight: 2, fillOpacity: 0 },
            onEachFeature: (feature, layer) => {
                layer.bindPopup(`<b>${feature.properties.nama_kecamatan}</b><br>${feature.properties.kota_admin}`);
            }
        }).addTo(map);
    }
    
    // Load Tsunami
    const tsunamiData = await fetchGeoJSON('tsunami');
    if (tsunamiData) {
        layers.tsunami = L.geoJSON(tsunamiData, {
            style: { color: '#0ea5e9', weight: 1, fillColor: '#0ea5e9', fillOpacity: 0.5 },
            onEachFeature: (feature, layer) => {
                layer.bindPopup(`<b>Zona Tsunami:</b> ${feature.properties.zona_tsunami}<br><b>Max Elevasi:</b> ${feature.properties.elevasi_max_m}m`);
            }
        });
    }

    // Load Pengungsian
    const pengungsianData = await fetchGeoJSON('pengungsian');
    if (pengungsianData) {
        layers.pengungsian = L.geoJSON(pengungsianData, {
            pointToLayer: (feature, latlng) => {
                return L.circleMarker(latlng, {
                    radius: 6,
                    fillColor: "#8b5cf6",
                    color: "#fff",
                    weight: 2,
                    opacity: 1,
                    fillOpacity: 0.9
                });
            },
            onEachFeature: (feature, layer) => {
                layer.bindPopup(`<b>${feature.properties.nama}</b><br>Kapasitas: ${feature.properties.kapasitas}<br>Fasilitas: ${feature.properties.fasilitas}`);
            }
        });
    }
}

async function updateLayers(currentFilters) {
    // Update Banjir Layer based on filters
    const banjirData = await fetchGeoJSON('banjir', currentFilters);
    
    if (layers.banjir) {
        map.removeLayer(layers.banjir);
    }

    if (banjirData && document.getElementById('layer-banjir').checked) {
        layers.banjir = L.geoJSON(banjirData, {
            style: (feature) => ({
                color: 'white',
                weight: 1,
                fillColor: getBanjirColor(feature.properties.tingkat_risiko),
                fillOpacity: 0.7
            }),
            onEachFeature: (feature, layer) => {
                layer.bindPopup(`<b>Risiko Banjir:</b> ${feature.properties.tingkat_risiko}<br><b>Luas:</b> ${feature.properties.luas_ha} Ha<br><b>Lokasi:</b> ${feature.properties.nama_kelurahan}`);
            }
        }).addTo(map);
    }
}

function setupLayerToggles() {
    const toggleLayer = (checkboxId, layerKey) => {
        const checkbox = document.getElementById(checkboxId);
        if (checkbox) {
            checkbox.addEventListener('change', (e) => {
                if (e.target.checked && layers[layerKey]) {
                    map.addLayer(layers[layerKey]);
                } else if (layers[layerKey]) {
                    map.removeLayer(layers[layerKey]);
                }
            });
        }
    };

    toggleLayer('layer-banjir', 'banjir');
    toggleLayer('layer-tsunami', 'tsunami');
    toggleLayer('layer-pengungsian', 'pengungsian');
}
