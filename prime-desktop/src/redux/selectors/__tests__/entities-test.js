import expect from 'expect'
import { visibleEntitiesSelector } from '../entities'

describe('visibleEntitiesSelector', () => {
  it('select visible entities', () => {
    const state = {
      entities: {
        cars: {
          1: { name: 'Audi' },
          2: { name: 'BMW' }
        }
      },
      cars: {
        ids: [2]
      }
    }

    expect(visibleEntitiesSelector('cars')(state)).toEqual([{ name: 'BMW' }])
  })
})
