import graphene
from django.conf import settings
from graphene_django.debug import DjangoDebug

from accounts.schema import Query as accountsQuery


class Query(accountsQuery, graphene.ObjectType):
    # This class will inherit from multiple Queries
    # as we begin to add more apps to our project
    pass


if settings.DEBUG:
    Query.debug = graphene.Field(DjangoDebug, name='__debug')

# noinspection PyTypeChecker
schema = graphene.Schema(query=Query)
