// Filter logic for updating map layers
const API_BASE_URL = 'http://localhost:5000/api';

async function fetchGeoJSON(endpoint, params = {}) {
    const url = new URL(`${API_BASE_URL}/${endpoint}`);
    Object.keys(params).forEach(key => {
        if(params[key]) url.searchParams.append(key, params[key]);
    });
    
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error(`Error fetching ${endpoint}:`, error);
        return null;
    }
}

// Global filter state
const filters = {
    kota: '',
    risiko: ''
};

function initFilters(updateMapCallback) {
    const kotaSelect = document.getElementById('filter-kota');
    if (kotaSelect) {
        kotaSelect.addEventListener('change', (e) => {
            filters.kota = e.target.value;
            updateMapCallback(filters);
        });
    }

    const risikoSelect = document.getElementById('filter-risiko');
    if (risikoSelect) {
        risikoSelect.addEventListener('change', (e) => {
            filters.risiko = e.target.value;
            updateMapCallback(filters);
        });
    }
}
