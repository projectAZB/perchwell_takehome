import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';

const Buildings = () => {
  const [buildings, setBuildings] = useState([]);
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
      setBuildings(data);
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
        // Remove the deleted building from the state
        setBuildings(buildings.filter(building => building.id !== buildingId));
      } catch (err) {
        setError(err.message);
      }
    }
  };

  if (isLoading) return <div>Loading buildings...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <h2>Buildings for Client {clientId}</h2>
      <Link to="/">Back to Clients</Link>
      {buildings.length === 0 ? (
        <p>No buildings found for this client.</p>
      ) : (
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Address</th>
              <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>State</th>
              <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Zip Code</th>
              <th style={{ border: '1px solid #ddd', padding: '8px', textAlign: 'left' }}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {buildings.map((building) => (
              <tr key={building.id}>
                <td style={{ border: '1px solid #ddd', padding: '8px' }}>{building.address}</td>
                <td style={{ border: '1px solid #ddd', padding: '8px' }}>{building.state}</td>
                <td style={{ border: '1px solid #ddd', padding: '8px' }}>{building.zip_code}</td>
                <td style={{ border: '1px solid #ddd', padding: '8px' }}>
                  <button onClick={() => handleDelete(building.id)} style={{ cursor: 'pointer' }}>
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default Buildings;
