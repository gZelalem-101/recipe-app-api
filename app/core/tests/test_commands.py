# """
# Test custom Django management commands.
# """
# from unittest.mock import patch

# from psycopg2 import OperationalError as Psycopg2OpError

# from django.core.management import call_command
# from django.db.utils import OperationalError
# from django.test import SimpleTestCase


# @patch('core.management.commands.wait_for_db.Command.check')
# class CommandTests(SimpleTestCase):
#     """Test commands."""

#     def test_wait_for_db_ready(self, patched_check):
#         """Test waiting for database if database ready."""
#         patched_check.return_value = True

#         call_command('wait_for_db')

#         patched_check.assert_called_once_with(databases=['default'])

#     @patch('time.sleep')
#     def test_wait_for_db_delay(self, patched_sleep, patched_check):
#         """Test waiting for database when getting OperationalError."""
#         patched_check.side_effect = [Psycopg2OpError] * 2 + \
#             [OperationalError] * 3 + [True]

#         call_command('wait_for_db')

#         self.assertEqual(patched_check.call_count, 6)
#         patched_check.assert_called_with(databases=['default'])

import time
from django.core.management import BaseCommand
from django.db.utils import OperationalError
from psycopg2 import OperationalError as Psycopg2OpError


class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        self.stdout.write("Checking database availability...\n")
        db_up = False
        while not db_up:
            try:
                self.check(databases=["default"])
                db_up = True
            except (Psycopg2OpError, OperationalError):
                self.stdout.write("Database not available, retrying...\n")
                time.sleep(1)
        self.stdout.write("Database is ready!\n")
