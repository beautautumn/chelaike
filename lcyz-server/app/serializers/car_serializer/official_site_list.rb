module CarSerializer
  class OfficialSiteList < ActiveModel::Serializer
    include CarSerializer::Che3baoConcern

    attributes :id, :stockId, :stockNo, :brandCode, :brandName, :seriesCode, :seriesName,
               :modelCode, :modelName, :vehicleName, :registerMonth, :mileageNum,
               :gearsType, :outputVolumn, :turboCharger, :carProvince, :carCity,
               :carPrice, :firstPic, :discTag, :stockState, :usedType, :newCarRefPrice,
               :instockDate, :updated_at, :corpName, :corpId, :corpPhone, :corpContact,
               :showCustInfo, :newCarHandprice, :sales_minimun_price_cents, :online_price_cents,
               :show_price_cents, :new_car_additional_price_cents, :mileage, :licensed_at,
               :emission_standard, :transmission, :displacement

    has_many :images, serializer: ImageSerializer::Common
  end
end
