
&НаКлиенте
Процедура ПриОткрытии(Отказ)
    штрихкод = Получитькомпоненту();  
	Элементы.QRКод.РазмерКартинки = РазмерКартинки.АвтоРазмер;
	//Волков ИО 16.02.24 ++
	Список.Параметры.УстановитьЗначениеПараметра("Стеллаж", объект.Ссылка);

	//Волков И О16.02.24 --
	
КонецПроцедуры  
&НаСервере
Функция Получитькомпоненту()
	ТекстОшибки = "";
	
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(ТекстОшибки); 
	Штрихкод.Ширина = 250; 
	Штрихкод.Высота = 250;
	Штрихкод.ТипКода = 16;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = объект.Наименование;
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод,Истина);
	
	QRкод = ПоместитьВоВременноеХранилище(КартинкаШтрихКод,УникальныйИдентификатор);
	возврат истина;
КонецФункции
