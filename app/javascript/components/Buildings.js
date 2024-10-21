import React, { useState, useEffect } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';

const Buildings = () => {
  const [buildingsData, setBuildingsData] = useState({
    clientName: '',
    buildings: [],
    totalPages: 0,
    currentPage: 1,
    totalCount: 0
  });
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { clientId } = useParams();
  const navigate = useNavigate();

  useEffect(() => {
    fetchBuildings();
  }, [clientId]);

  const getCsrfToken = () => {
    return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  };

  const fetchBuildings = async (page = 1) => {
    setIsLoading(true);
    try {
      const response = await fetch(`/clients/${clientId}/buildings?page=${page}`);
      if (!response.ok) {
        throw new Error('Failed to fetch buildings');
      }
      const data = await response.json();
      setBuildingsData({
        clientName: data.client_name,
        buildings: data.buildings,
        totalPages: data.total_pages,
        currentPage: data.current_page,
        totalCount: data.total_count
      });
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  const handlePageChange = (newPage) => {
    fetchBuildings(newPage);
  };

  const handleDelete = async (buildingId) => {
    if (window.confirm('Are you sure you want to delete this building?')) {
      try {
        const response = await fetch(`/clients/${clientId}/buildings/${buildingId}`, {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': getCsrfToken(),
          },
        });
        if (!response.ok) {
          throw new Error('Failed to delete building');
        }
        setBuildingsData(prevData => ({
          ...prevData,
          buildings: prevData.buildings.filter(building => building.id !== buildingId),
          totalCount: prevData.totalCount - 1
        }));
      } catch (err) {
        setError(err.message);
      }
    }
  };

  const handleEdit = (buildingId) => {
    navigate(`/clients/${clientId}/buildings/${buildingId}/edit`);
  };

  const handleAddBuilding = () => {
    navigate(`/clients/${clientId}/buildings/new`);
  };

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div style={{ padding: '20px' }}>
      <h2 style={{ marginBottom: '20px' }}>Buildings for {buildingsData.clientName}</h2>
      <Link to="/" style={{ marginBottom: '20px', display: 'inline-block' }}>Back to Clients</Link>
      {buildingsData.buildings.length === 0 ? (
        <p>No buildings found for this client.</p>
      ) : (
        <>
          <table style={{ width: '100%', borderCollapse: 'collapse', marginTop: '20px' }}>
            <thead>
              <tr>
                <th style={{ border: '1px solid #ddd', padding: '12px', textAlign: 'left', backgroundColor: '#f2f2f2' }}>Address</th>
                <th style={{ border: '1px solid #ddd', padding: '12px', textAlign: 'left', backgroundColor: '#f2f2f2' }}>State</th>
                <th style={{ border: '1px solid #ddd', padding: '12px', textAlign: 'left', backgroundColor: '#f2f2f2' }}>Zip Code</th>
                <th style={{ border: '1px solid #ddd', padding: '12px', textAlign: 'left', backgroundColor: '#f2f2f2' }}>Custom Fields</th>
                <th style={{ border: '1px solid #ddd', padding: '12px', textAlign: 'left', backgroundColor: '#f2f2f2' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {buildingsData.buildings.map((building) => (
                <tr key={building.id}>
                  <td style={{ border: '1px solid #ddd', padding: '12px' }}>{building.address}</td>
                  <td style={{ border: '1px solid #ddd', padding: '12px' }}>{building.state}</td>
                  <td style={{ border: '1px solid #ddd', padding: '12px' }}>{building.zip_code}</td>
                  <td style={{ border: '1px solid #ddd', padding: '12px' }}>
                    {Object.entries(building.custom_field_values).map(([name, value]) => (
                      <div key={name}>
                        <strong>{name}:</strong> {value}
                      </div>
                    ))}
                  </td>
                  <td style={{ border: '1px solid #ddd', padding: '12px' }}>
                    <button 
                      onClick={() => handleEdit(building.id)} 
                      style={{ marginRight: '10px', padding: '5px 10px', cursor: 'pointer', backgroundColor: '#4CAF50', color: 'white', border: 'none', borderRadius: '3px' }}
                    >
                      Edit
                    </button>
                    <button 
                      onClick={() => handleDelete(building.id)} 
                      style={{ padding: '5px 10px', cursor: 'pointer', backgroundColor: '#f44336', color: 'white', border: 'none', borderRadius: '3px' }}
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <div style={{ marginTop: '20px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <button 
              onClick={() => handlePageChange(buildingsData.currentPage - 1)} 
              disabled={buildingsData.currentPage === 1}
              style={{ padding: '5px 10px', cursor: buildingsData.currentPage === 1 ? 'not-allowed' : 'pointer', backgroundColor: '#008CBA', color: 'white', border: 'none', borderRadius: '3px' }}
            >
              Previous
            </button>
            <span>Page {buildingsData.currentPage} of {buildingsData.totalPages}</span>
            <button 
              onClick={() => handlePageChange(buildingsData.currentPage + 1)} 
              disabled={buildingsData.currentPage === buildingsData.totalPages}
              style={{ padding: '5px 10px', cursor: buildingsData.currentPage === buildingsData.totalPages ? 'not-allowed' : 'pointer', backgroundColor: '#008CBA', color: 'white', border: 'none', borderRadius: '3px' }}
            >
              Next
            </button>
          </div>
          <div style={{ marginTop: '10px' }}>
            Total buildings: {buildingsData.totalCount}
          </div>
        </>
      )}
      <button 
        onClick={handleAddBuilding}
        style={{ 
          marginTop: '20px', 
          padding: '10px 15px', 
          backgroundColor: '#4CAF50', 
          color: 'white', 
          border: 'none', 
          borderRadius: '5px', 
          cursor: 'pointer',
          fontSize: '16px'
        }}
      >
        Add New Building
      </button>
    </div>
  );
};

export default Buildings;
