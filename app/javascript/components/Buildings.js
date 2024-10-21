import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';

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

  useEffect(() => {
    fetchBuildings();
  }, [clientId]);

  const fetchBuildings = async () => {
    setIsLoading(true);
    try {
      const response = await fetch(`/clients/${clientId}/buildings`);
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

  const handleDelete = async (buildingId) => {
    if (window.confirm('Are you sure you want to delete this building?')) {
      try {
        const response = await fetch(`/clients/${clientId}/buildings/${buildingId}`, {
          method: 'DELETE',
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

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <h2>Buildings for {buildingsData.clientName}</h2>
      <Link to="/">Back to Clients</Link>
      {buildingsData.buildings.length === 0 ? (
        <p>No buildings found for this client.</p>
      ) : (
        <>
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr>
                <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Address</th>
                <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>State</th>
                <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Zip Code</th>
                <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Custom Fields</th>
                <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {buildingsData.buildings.map((building) => (
                <tr key={building.id}>
                  <td style={{ border: '1px solid #ddd', padding: '8px' }}>{building.address}</td>
                  <td style={{ border: '1px solid #ddd', padding: '8px' }}>{building.state}</td>
                  <td style={{ border: '1px solid #ddd', padding: '8px' }}>{building.zip_code}</td>
                  <td style={{ border: '1px solid #ddd', padding: '8px' }}>
                    {Object.entries(building.custom_field_values).map(([key, value]) => (
                      <div key={key}>
                        {key}: {value}
                      </div>
                    ))}
                  </td>
                  <td style={{ border: '1px solid #ddd', padding: '8px' }}>
                    <button onClick={() => handleDelete(building.id)} style={{ cursor: 'pointer' }}>
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <div>
            Page {buildingsData.currentPage} of {buildingsData.totalPages}
          </div>
          <div>
            Total buildings: {buildingsData.totalCount}
          </div>
        </>
      )}
    </div>
  );
};

export default Buildings;
