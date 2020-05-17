import { createValidator, required } from 'utils/validation'

const intentionValidator = createValidator({
  customerPhone: [required],
  channelId: [required],
})

const appoitmentCarValidator = createValidator({
  appointmentTime: [required],
})


export default function validation(data) {
  const errors = intentionValidator(data)

  if (data.appoitment === true) {
    errors.appoitmentCar = appoitmentCarValidator(data.appoitmentCar)
  }

  return errors
}
