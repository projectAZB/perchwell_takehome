import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';

const EditBuilding = () => {
  const [building, setBuilding] = useState(null);
  const [customFields, setCustomFields] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { clientId, buildingId } = useParams();
  const navigate = useNavigate();

  useEffect(() => {
    fetchBuildingAndCustomFields();
  }, [clientId, buildingId]);

  const fetchBuildingAndCustomFields = async () => {
    setIsLoading(true);
    try {
      const [buildingResponse, customFieldsResponse] = await Promise.all([
        fetch(`/clients/${clientId}/buildings/${buildingId}`),
        fetch(`/clients/${clientId}/custom_fields`)
      ]);

      if (!buildingResponse.ok || !customFieldsResponse.ok) {
        throw new Error('Failed to fetch data');
      }

      const buildingData = await buildingResponse.json();
      const customFieldsData = await customFieldsResponse.json();

      setBuilding(buildingData);
      setCustomFields(customFieldsData);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setBuilding({ ...building, [name]: value });
  };

  const handleCustomFieldChange = (fieldId, value) => {
    setBuilding({
      ...building,
      custom_field_values: {
        ...building.custom_field_values,
        [fieldId]: value
      }
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`/clients/${clientId}/buildings/${buildingId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(building),
      });

      if (!response.ok) {
        throw new Error('Failed to update building');
      }

      navigate(`/clients/${clientId}/buildings`);
    } catch (err) {
      setError(err.message);
    }
  };

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!building) return <div>Building not found</div>;

  return (
    <div>
      <h2>Edit Building</h2>
      <Link to={`/clients/${clientId}/buildings`}>Back to Buildings</Link>
      <form onSubmit={handleSubmit} style={{ marginTop: '20px' }}>
        <div>
          <label htmlFor="address">Address:</label>
          <input
            type="text"
            id="address"
            name="address"
            value={building.address}
            onChange={handleInputChange}
            required
          />
        </div>
        <div>
          <label htmlFor="state">State:</label>
          <input
            type="text"
            id="state"
            name="state"
            value={building.state}
            onChange={handleInputChange}
            required
          />
        </div>
        <div>
          <label htmlFor="zip_code">Zip Code:</label>
          <input
            type="text"
            id="zip_code"
            name="zip_code"
            value={building.zip_code}
            onChange={handleInputChange}
            required
          />
        </div>
        <h3>Custom Fields</h3>
        {customFields.map((field) => (
          <div key={field.id}>
            <label htmlFor={`custom_field_${field.id}`}>{field.name}:</label>
            <input
              type="text"
              id={`custom_field_${field.id}`}
              value={building.custom_field_values[field.id] || ''}
              onChange={(e) => handleCustomFieldChange(field.id, e.target.value)}
            />
          </div>
        ))}
        <button type="submit" style={{ marginTop: '20px' }}>Update Building</button>
      </form>
    </div>
  );
};

export default EditBuilding;