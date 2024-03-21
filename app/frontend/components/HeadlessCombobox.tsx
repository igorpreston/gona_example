import React, {Fragment, useState, useRef, useEffect} from 'react'
import classNames from 'classnames'
import { useClickAway } from 'react-use'
import { Combobox } from '@headlessui/react'
import { CheckIcon, ChevronUpDownIcon, TagIcon } from '@heroicons/react/20/solid'
import { XMarkIcon } from '@heroicons/react/20/solid'

const exampleOptions = [
  { id: 1, name: 'Option 1' },
  { id: 2, name: 'Option 2' },
  { id: 3, name: 'Option 3' },
  { id: 4, name: 'Option 4' },
  { id: 5, name: 'Option 5' }
]

const comboboxInputWrapperClasses = "input pr-8"
const comboboxInputClasses = "flex-1 pl-2 inline truncate border-0 outline-0 focus:ring-0 p-0 bg-inherit text-inherit"
const comboboxButtonClasses = "absolute inset-y-0 right-0 flex pt-3.5 rounded-r-md px-2 focus:outline-none"
const comboboxOptionsClasses = "absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
const comboboxOptionClasses = "relative cursor-default select-none py-2 pl-3 pr-9"
const comboboxOptionActiveClasses = "bg-blue-600 text-white"
const comboboxOptionInactiveClasses = "text-gray-900"
const comboboxOptionSelectedClasses = ""

type HeadlessComboboxProps = {
  label: string
  id: string
  initialOptions: Array<{}>
  initialSelected: Array<{}> | {} | null
  newOption: {}
  displayKey: string
  inputKey: string
  newOptionInputKey: string | null
  newOptionValueKey: string | null
  valueKey: string
  previewKey: string | null
  multiple: boolean
  placeholder: string | null
  withPreview: boolean
}

type ComboboxHiddenInputProps = {
  name: string
  value: string
}

const ComboboxHiddenInput: React.FC<ComboboxHiddenInputProps> = ({ name, value }) => (
  <input type="hidden" name={name} value={value} />
)

export default function HeadlessCombobox({
                                           label = null,
                                           id = null,
                                           initialOptions = exampleOptions,
                                           initialSelected = null,
                                           newOption,
                                           displayKey,
                                           inputKey,
                                           newOptionInputKey = null,
                                           newOptionValueKey = null,
                                           previewKey = null,
                                           valueKey,
                                           multiple = false,
                                           placeholder = null,
                                           withPreview = false
                                         }: HeadlessComboboxProps) {
  const [options, _] = useState(initialOptions)

  const comboboxRef = useRef(null)
  const comboboxBodyRef = useRef(null)

  const initialSelectedValue =
    multiple
      ? initialSelected ? options.filter(option => (initialSelected as Array<{}>).find(initialOption => option[valueKey] === initialOption[valueKey])) : []
      : initialSelected ? options.find(option => initialSelected[valueKey] === option[valueKey]) : null

  const [selected, setSelected] = useState(initialSelectedValue)
  const [query, setQuery] = useState('')
  const [isComboboxOpen, setComboboxOpen] = useState(false)
  const [isComboboxFocused, setComboboxFocused] = useState(false)

  const filteredOptions =
    query === ''
      ? options
      : options.filter(option => option[displayKey].toLowerCase().includes(query.toLowerCase()))

  useClickAway(comboboxBodyRef, () => setComboboxOpen(false))

  return (
    <Combobox as="div" value={selected} onChange={setSelected} multiple={multiple} ref={comboboxRef}>
      {label && <Combobox.Label htmlFor={id} className="label">{label}</Combobox.Label>}
      <div ref={comboboxBodyRef} className="relative mt-1">
        <div className={classNames(comboboxInputWrapperClasses, { 'bg-white border-blue-500': isComboboxFocused, 'border-transparent': !isComboboxFocused })}>
          <div className="flex flex-wrap flex-1 gap-1">
            {multiple && selected.map((option, index) => (
              <span
                key={option.id}
                className="inline-flex items-center rounded bg-blue-100 text-sm font-medium text-blue-800"
              >
                {withPreview && previewKey ? option[previewKey] ? (
                  <img src={option[previewKey]} className="ml-1 w-4 h-4 object-fit rounded shadow-sm" />
                ) : (
                  <svg
                    className="ml-1 w-4 h-4 object-fit rounded shadow-sm"
                    version="1.1"
                    id="Layer_1"
                    xmlns="http://www.w3.org/2000/svg"
                    xmlnsXlink="http://www.w3.org/1999/xlink"
                    x="0px"
                    y="0px"
                    width="100%"
                    height="100%"
                    viewBox="89.437 -10.563 621.127 621.127"
                    enableBackground="new 89.437 -10.563 621.127 621.127"
                    xmlSpace="preserve">
                    <rect x="109.437" y="10" className="fill-gray-400" width="581.127" height="580.562" />
                    <g transform="translate(-5.000000, -5.000000)">
                      <path
                        className="fill-gray-100"
                        d="M94.437-5.563h621.127v621.127H94.437V-5.563L94.437-5.563z M475.346,254.057l-8.185-47.831L299.63,235.641
                l24.553,139.908l16.627-2.813v12.021h170.087V254.057H475.346L475.346,254.057z M340.811,358.666l-5.371,1.021l-19.95-112.794
                l140.419-24.812l5.628,31.974H340.811V358.666L340.811,358.666L340.811,358.666z M497.087,370.943H354.621V267.868h142.466V370.943
                L497.087,370.943z M363.828,277.075v76.474l28.903-19.181l17.903,11.252l43.48-47.829l5.629,2.301l28.134,32.485v-55.502H363.828
                L363.828,277.075L363.828,277.075z M391.451,310.068c-6.648,0-12.276-5.626-12.276-12.277c0-6.65,5.628-12.279,12.276-12.279
                c6.651,0,12.276,5.626,12.276,12.279C403.729,304.442,398.102,310.068,391.451,310.068L391.451,310.068L391.451,310.068z"/>
                    </g>
                  </svg>
                ) : null}
                <span className="py-0.5 pl-1.5">{option.name}</span>
                <span
                  className="px-1"
                  onClick={() => {
                    setSelected([...selected.slice(0, index), ...selected.slice(index + 1)])
                  }}
                >
                  <XMarkIcon
                    className="w-4 h-4 hover:bg-red-300 hover:text-red-800 rounded cursor-pointer"
                  />
                </span>
              </span>
            ))}
            <Combobox.Input
              id={id}
              className={classNames(comboboxInputClasses, { 'pl-1': multiple && selected.length > 0 })}
              autoComplete="off"
              placeholder={placeholder}
              displayValue={value => multiple ? query : value && value[displayKey]}
              onChange={event => {
                if (!multiple) {
                  if (event.target.value.length === 0) {
                    setSelected(null)
                  }
                }
                setQuery(event.target.value)
              }}
              onFocus={() => {
                setComboboxOpen(true)
                setComboboxFocused(true)
              }}
              onBlur={() => setComboboxFocused(false)}
              onKeyDown={event => {
                if (multiple && selected.length > 0 && query.length === 0 && event.key === 'Backspace') {
                  const indexToRemove = selected.length - 1
                  setSelected([...selected.slice(0, indexToRemove), ...selected.slice(indexToRemove + 1)])
                }
              }}
            />
          </div>
          <Combobox.Button
            className={comboboxButtonClasses}
          >
            <ChevronUpDownIcon
              className="h-5 w-5 text-gray-400"
              aria-hidden="true"
            />
          </Combobox.Button>
        </div>
        {isComboboxOpen && (<Combobox.Options className={comboboxOptionsClasses} static>
          {!multiple && query.length > 0 && (
            <Combobox.Option
              className={({ active }) => classNames(
                comboboxOptionClasses,
                {
                  [comboboxOptionActiveClasses]: active,
                  [comboboxOptionInactiveClasses]: !active
                }
              )}
              value={{...newOption, newOption: true, [displayKey]: query }}
              onClick={() => !multiple && setComboboxOpen(false)}
            >
              Create "{query}"
            </Combobox.Option>
          )}
          {filteredOptions && filteredOptions.length >= 1 ? filteredOptions.map(option => (
            <Combobox.Option
              key={option[valueKey]}
              value={option}
              className={({ active, selected }) => classNames(
                comboboxOptionClasses,
                {
                  [comboboxOptionActiveClasses]: active,
                  [comboboxOptionInactiveClasses]: !active,
                  [comboboxOptionSelectedClasses]: selected
                }
              )}
              onClick={() => !multiple && setComboboxOpen(false)}
            >
              {({ active, selected }) => (
                <Fragment>
                  <span className="flex items-center">
                  {previewKey ? option[previewKey] ? (
                    <img src={option[previewKey]} className="w-8 h-8 object-fit rounded shadow-sm" />
                  ) : (
                    <svg
                      className="w-8 h-8 object-fit rounded shadow-sm"
                      version="1.1"
                      id="Layer_1"
                      xmlns="http://www.w3.org/2000/svg"
                      xmlnsXlink="http://www.w3.org/1999/xlink"
                      x="0px"
                      y="0px"
                      width="100%"
                      height="100%"
                      viewBox="89.437 -10.563 621.127 621.127"
                      enableBackground="new 89.437 -10.563 621.127 621.127"
                      xmlSpace="preserve">
                      <rect x="109.437" y="10" className="fill-gray-400" width="581.127" height="580.562" />
                      <g transform="translate(-5.000000, -5.000000)">
                        <path
                          className="fill-gray-100"
                          d="M94.437-5.563h621.127v621.127H94.437V-5.563L94.437-5.563z M475.346,254.057l-8.185-47.831L299.63,235.641
                l24.553,139.908l16.627-2.813v12.021h170.087V254.057H475.346L475.346,254.057z M340.811,358.666l-5.371,1.021l-19.95-112.794
                l140.419-24.812l5.628,31.974H340.811V358.666L340.811,358.666L340.811,358.666z M497.087,370.943H354.621V267.868h142.466V370.943
                L497.087,370.943z M363.828,277.075v76.474l28.903-19.181l17.903,11.252l43.48-47.829l5.629,2.301l28.134,32.485v-55.502H363.828
                L363.828,277.075L363.828,277.075z M391.451,310.068c-6.648,0-12.276-5.626-12.276-12.277c0-6.65,5.628-12.279,12.276-12.279
                c6.651,0,12.276,5.626,12.276,12.279C403.729,304.442,398.102,310.068,391.451,310.068L391.451,310.068L391.451,310.068z"/>
                      </g>
                    </svg>
                  ) : null}
                    <span
                      className={classNames(
                        'block truncate ml-2',
                        { 'font-semibold': selected }
                      )}
                    >
                    {option[displayKey]}
                  </span>

                    {selected && (
                      <span
                        className={classNames(
                          'absolute inset-y-0 right-0 flex items-center pr-4',
                          {
                            'text-white': active,
                            'text-blue-600': !active
                          }
                        )}
                      >
                      <CheckIcon className="h-5 w-5" aria-hidden="true" />
                    </span>
                    )}
                  </span>
                </Fragment>
              )}
            </Combobox.Option>
          )) : (
            <Combobox.Option
              className={({ active }) => classNames(
                comboboxOptionClasses,
                {
                  [comboboxOptionInactiveClasses]: !active
                }
              )}
              value={null}
              onClick={e => e.preventDefault()}
            >
              No options matching "{query}"
            </Combobox.Option>
          )}
        </Combobox.Options>)}
        {multiple ? (
          selected && selected.length >= 1 ? selected.map(selectedOption => (
            <ComboboxHiddenInput
              key={selectedOption[valueKey]}
              name={inputKey}
              value={selectedOption[valueKey]}
            />
          )) : (
            <ComboboxHiddenInput
              name={inputKey}
              value=""
            />
          )
        ) : selected && (
          <ComboboxHiddenInput
            name={selected.newOption ? newOptionInputKey : inputKey}
            value={selected.newOption ? selected[newOptionValueKey] : selected[valueKey]}
          />
        )}
      </div>
    </Combobox>
  )
}
