import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';

const AddBuilding = () => {
  const [building, setBuilding] = useState({
    address: '',
    state: '',
    zip_code: '',
    custom_field_values: {}
  });
  const [customFields, setCustomFields] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [validationErrors, setValidationErrors] = useState({});
  const { clientId } = useParams();
  const navigate = useNavigate();

  const getCsrfToken = () => {
    return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  };

  useEffect(() => {
    fetchCustomFields();
  }, [clientId]);

  const fetchCustomFields = async () => {
    setIsLoading(true);
    try {
      const response = await fetch(`/clients/${clientId}/custom_fields`);
      if (!response.ok) {
        throw new Error('Failed to fetch custom fields');
      }
      const data = await response.json();
      setCustomFields(data);
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
    setError(null);
    setValidationErrors({});

    // Filter out blank custom field values
    const filteredCustomFieldValues = Object.entries(building.custom_field_values).reduce((acc, [key, value]) => {
      if (value.trim() !== '') {
        acc[key] = value.trim();
      }
      return acc;
    }, {});

    const buildingData = {
      ...building,
      custom_field_values: filteredCustomFieldValues
    };

    try {
      const response = await fetch(`/clients/${clientId}/buildings`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': getCsrfToken(),
        },
        body: JSON.stringify(buildingData),
      });

      if (!response.ok) {
        const errorData = await response.json();
        if (response.status === 422) {
          // Validation errors
          setValidationErrors(errorData.errors || {});
        } else {
          throw new Error(errorData.message || 'Failed to create building');
        }
      } else {
        navigate(`/clients/${clientId}/buildings`);
      }
    } catch (err) {
      setError(err.message);
    }
  };

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div style={{ padding: '20px' }}>
      <h2 style={{ marginBottom: '20px' }}>Add New Building</h2>
      <Link to={`/clients/${clientId}/buildings`} style={{ marginBottom: '20px', display: 'inline-block' }}>Back to Buildings</Link>
      {Object.keys(validationErrors).length > 0 && (
        <div style={{ marginBottom: '20px', color: 'red', backgroundColor: '#ffeeee', padding: '10px', borderRadius: '5px' }}>
          <h3>Errors:</h3>
          <ul>
            {Object.entries(validationErrors).map(([field, errors]) => (
              <li key={field}>{`${field}: ${errors.join(', ')}`}</li>
            ))}
          </ul>
        </div>
      )}
      <form onSubmit={handleSubmit} style={{ marginTop: '20px' }}>
        <div style={{ marginBottom: '15px' }}>
          <label htmlFor="address" style={{ display: 'block', marginBottom: '5px' }}>Address:</label>
          <input
            type="text"
            id="address"
            name="address"
            value={building.address}
            onChange={handleInputChange}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>
        <div style={{ marginBottom: '15px' }}>
          <label htmlFor="state" style={{ display: 'block', marginBottom: '5px' }}>State:</label>
          <input
            type="text"
            id="state"
            name="state"
            value={building.state}
            onChange={handleInputChange}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>
        <div style={{ marginBottom: '15px' }}>
          <label htmlFor="zip_code" style={{ display: 'block', marginBottom: '5px' }}>Zip Code:</label>
          <input
            type="text"
            id="zip_code"
            name="zip_code"
            value={building.zip_code}
            onChange={handleInputChange}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>
        <h3 style={{ marginTop: '20px', marginBottom: '10px' }}>Custom Fields</h3>
        {customFields.map((field) => (
          <div key={field.id} style={{ marginBottom: '15px' }}>
            <label htmlFor={`custom_field_${field.id}`} style={{ display: 'block', marginBottom: '5px' }}>{field.name}:</label>
            <input
              type="text"
              id={`custom_field_${field.id}`}
              value={building.custom_field_values[field.id] || ''}
              onChange={(e) => handleCustomFieldChange(field.id, e.target.value)}
              style={{ width: '100%', padding: '8px' }}
            />
          </div>
        ))}
        <button 
          type="submit" 
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
          Create Building
        </button>
      </form>
    </div>
  );
};

export default AddBuilding;