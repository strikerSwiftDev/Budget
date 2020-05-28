
import Foundation

class Consts {
    
    static let isDebugBuild = true
    
    static let wrongDate = Date(timeIntervalSince1970: 0)
    
    static let categoriesEmptyPlaceholder = "Нет категорий"
    static let subcategoriesEmptyPlaceholder = "Нет подкатегорий (плейсхолдер)"
    static let subcategoriesUcategorized = "Нет подкатегорий (плейсхолдер)"

    static let categorieTitleMaxSymbols = 18
    
    static let defaultCategories = ["Еда", "Авто", "Дом", "Работа", "Одежда", "Путешествия"]
    
    static let defaultSubCategories = ["Еда": ["Картошка", "Морковка"],
                                       "Авто": ["Бензин","Газ","Ремонт","Мойка"],
                                       "Дом": ["Для уборки","Интерьер","Кот","Собака"],
                                       "Работа": ["Зарплата","Аванс"],
                                       "Одежда": ["Верхняя","Нижняя","Аксессуары",
                                                "Украшения", "Английский"]]
    static let strCurrency = "Uah"
}


