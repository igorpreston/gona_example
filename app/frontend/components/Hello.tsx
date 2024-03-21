import React from 'react'

export default function Hello({ name }) {
  return (
    <div>
      {name || 'Hello World'}
    </div>
  )
}
