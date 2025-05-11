class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un correo electrónico';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese una contraseña';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un precio';
    }
    
    try {
      final price = double.parse(value);
      if (price <= 0) {
        return 'El precio debe ser mayor a 0';
      }
    } catch (e) {
      return 'Por favor ingrese un precio válido';
    }
    
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese una URL';
    }
    
    final urlRegExp = RegExp(
      r'^(http|https)://'
      r'([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}'
      r'(/[\w\-\.,@?^=%&:/~\+#]*)*$'
    );
    
    if (!urlRegExp.hasMatch(value) && !value.startsWith('http')) {
      return 'Por favor ingrese una URL válida (debe comenzar con http:// o https://)';
    }
    
    return null;
  }
}
