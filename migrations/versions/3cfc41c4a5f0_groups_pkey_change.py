"""groups pkey change

Revision ID: 3cfc41c4a5f0
Revises: 53927300c277
Create Date: 2012-06-27 02:15:58.776223

"""

# revision identifiers, used by Alembic.
revision = '3cfc41c4a5f0'
down_revision = '53927300c277'

from alembic import op
import sqlalchemy as sa


def upgrade():
    with op.batch_alter_table('groups', schema=None) as batch_op:
        batch_op.drop_column('id')
    with op.batch_alter_table('groups', schema=None) as batch_op:
        batch_op.alter_column('group_name',
                    type_=sa.String(128),
                    existing_type=sa.String(50),
                    )
    with op.batch_alter_table('groups', schema=None) as batch_op:
        batch_op.create_primary_key('groups_pkey', columns=['group_name'])


def downgrade():
    pass
