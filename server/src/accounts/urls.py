from django.urls import path
from rest_framework.routers import DefaultRouter


from accounts.views import ValidateUniqueFields, CreateAccount, ChangePassword

app_name = 'accounts'

router = DefaultRouter()

urlpatterns = [
    path('validate/', ValidateUniqueFields.as_view()),
    path('change-password/', ChangePassword.as_view()),
    path('create/', CreateAccount.as_view()),
]

urlpatterns += router.urls
