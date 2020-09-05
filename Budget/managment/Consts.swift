
import Foundation

class Consts {
    
    static let isDebugBuild = true
    
    static let wrongDate = Date(timeIntervalSince1970: 0)
    
    static let categoriesEmptyPlaceholder = "< ПУСТО >"
    static let subcategoriesEmptyPlaceholder = "< ПУСТО >"
    
    static let subcategoriesUcategorized = "Общее"
    static let allString = "< ВСЕ >"

    static let categorieTitleMaxSymbols = 18

    static let defaultStrCurrency = "Uah"

    static let weekDaysForMondayUa = ["ПН","ВТ","СР","ЧТ","ПТ","СБ","НД"]
    static let weekDaysForSundayUa = ["НД","ПН","ВТ","СР","ЧТ","ПТ","СБ"]
    static let weekDaysForMondayRus = ["ПН","ВТ","СР","ЧТ","ПТ","СБ","ВС"]
    static let weekDaysForSundayRus = ["ВС","ПН","ВТ","СР","ЧТ","ПТ","СБ"]
    static let weekDaysForMondayEn = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    static let weekDaysForSundayEn = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    
    
    static let defaultCategoriesUa = ["Еда", "Авто", "Дом", "Работа", "Одежда", "Путешествия"]
    
    static let defaultSubCategoriesUa = ["Еда": [subcategoriesUcategorized, "Картошка", "Морковка"],
                                       "Авто": [subcategoriesUcategorized, "Бензин","Газ","Ремонт","Мойка"],
                                       "Дом": [subcategoriesUcategorized, "Для уборки","Интерьер","Кот","Собака"],
                                       "Работа": [subcategoriesUcategorized, "Зарплата","Аванс"],
                                       "Одежда": [subcategoriesUcategorized, "Верхняя","Нижняя","Аксессуары",
                                                "Украшения", "Английский"],
                                       "Путешествия": [subcategoriesUcategorized]]
    
    
    //
    //
    //
    
    static let defaultCategoriesRus = ["Еда", "Авто", "Дом", "Работа", "Одежда", "Путешествия"]
    
    static let defaultSubCategoriesRus = ["Еда": [subcategoriesUcategorized, "Картошка", "Морковка"],
                                       "Авто": [subcategoriesUcategorized, "Бензин","Газ","Ремонт","Мойка"],
                                       "Дом": [subcategoriesUcategorized, "Для уборки","Интерьер","Кот","Собака"],
                                       "Работа": [subcategoriesUcategorized, "Зарплата","Аванс"],
                                       "Одежда": [subcategoriesUcategorized, "Верхняя","Нижняя","Аксессуары",
                                                "Украшения", "Английский"],
                                       "Путешествия": [subcategoriesUcategorized]]
    
    
    
    
    static let defaultCategoriesEn = ["Еда", "Авто", "Дом", "Работа", "Одежда", "Путешествия"]
    
    static let defaultSubCategoriesEn = ["Еда": [subcategoriesUcategorized, "Картошка", "Морковка"],
                                       "Авто": [subcategoriesUcategorized, "Бензин","Газ","Ремонт","Мойка"],
                                       "Дом": [subcategoriesUcategorized, "Для уборки","Интерьер","Кот","Собака"],
                                       "Работа": [subcategoriesUcategorized, "Зарплата","Аванс"],
                                       "Одежда": [subcategoriesUcategorized, "Верхняя","Нижняя","Аксессуары",
                                                "Украшения", "Английский"],
                                       "Путешествия": [subcategoriesUcategorized]]
    
    
}


